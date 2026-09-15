package main

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

type fakeDB struct {
	sql    string
	params map[string]string
	rows   string
	err    error
}

func (f *fakeDB) Query(ctx context.Context, sql string, params map[string]string, out any) error {
	f.sql = sql
	f.params = params
	if f.err != nil {
		return f.err
	}
	return json.Unmarshal([]byte(f.rows), out)
}

func call(t *testing.T, db *fakeDB, path string) *httptest.ResponseRecorder {
	t.Helper()
	rec := httptest.NewRecorder()
	NewAPI(db).Routes().ServeHTTP(rec, httptest.NewRequest(http.MethodGet, path, nil))
	return rec
}

func TestMetricIsBoundAsParameterSoUserInputNeverBecomesSQL(t *testing.T) {
	db := &fakeDB{rows: `[]`}
	hostile := "latency_ms' OR 1=1 --"
	rec := call(t, db, "/api/top?metric="+strings.ReplaceAll(hostile, " ", "%20")+"&minutes=15")
	if rec.Code != http.StatusOK {
		t.Fatalf("status %d", rec.Code)
	}
	if strings.Contains(db.sql, "OR 1=1") {
		t.Fatalf("user input leaked into the SQL text: %s", db.sql)
	}
	if db.params["metric"] != hostile {
		t.Fatalf("metric must travel as a bound parameter, got %q", db.params["metric"])
	}
	if !strings.Contains(db.sql, "{metric:String}") {
		t.Fatalf("query must reference the metric placeholder")
	}
}

func TestWindowOutsideOneDayIsRejectedBeforeHittingClickHouse(t *testing.T) {
	for _, minutes := range []string{"0", "1441", "abc", "-5"} {
		db := &fakeDB{rows: `[]`}
		rec := call(t, db, "/api/summary?minutes="+minutes)
		if rec.Code != http.StatusBadRequest {
			t.Fatalf("minutes=%s: expected 400, got %d", minutes, rec.Code)
		}
		if db.sql != "" {
			t.Fatalf("minutes=%s: invalid input must not reach clickhouse", minutes)
		}
	}
}

func TestMissingMetricIsRejected(t *testing.T) {
	db := &fakeDB{rows: `[]`}
	if rec := call(t, db, "/api/timeseries"); rec.Code != http.StatusBadRequest {
		t.Fatalf("expected 400, got %d", rec.Code)
	}
}

func TestDefaultsKeepDashboardOnLastHourAndTopFive(t *testing.T) {
	db := &fakeDB{rows: `[]`}
	call(t, db, "/api/top?metric=cpu_percent")
	if db.params["minutes"] != "60" || db.params["limit"] != "5" {
		t.Fatalf("unexpected defaults %v", db.params)
	}
}

func TestClickHouseFailureIsBadGatewayWithoutLeakingInternals(t *testing.T) {
	db := &fakeDB{err: errors.New("Code: 516. Authentication failed: password is incorrect")}
	rec := call(t, db, "/api/stats")
	if rec.Code != http.StatusBadGateway {
		t.Fatalf("expected 502, got %d", rec.Code)
	}
	if strings.Contains(rec.Body.String(), "password") {
		t.Fatalf("clickhouse error details must not reach the client: %s", rec.Body.String())
	}
}

func TestStepKeepsChartsAroundSixtyBuckets(t *testing.T) {
	cases := map[int]int{15: 15, 60: 60, 360: 360, 1440: 1440, 5: 10}
	for minutes, want := range cases {
		if got := stepFor(minutes); got != want {
			t.Fatalf("stepFor(%d) = %d, want %d", minutes, got, want)
		}
		if minutes >= 10 && minutes*60/stepFor(minutes) != 60 {
			t.Fatalf("window %d does not produce 60 buckets", minutes)
		}
	}
}

func TestTimeseriesGroupsRowsPerServiceInMilliseconds(t *testing.T) {
	db := &fakeDB{rows: `[
		{"service":"auth","t":100,"v":1.5},
		{"service":"auth","t":160,"v":2.5},
		{"service":"payments","t":100,"v":9}
	]`}
	rec := call(t, db, "/api/timeseries?metric=latency_ms&minutes=60")
	var body Timeseries
	if err := json.Unmarshal(rec.Body.Bytes(), &body); err != nil {
		t.Fatal(err)
	}
	if body.Step != 60 || len(body.Series) != 2 {
		t.Fatalf("unexpected body %+v", body)
	}
	if body.Series[0].Service != "auth" || len(body.Series[0].Points) != 2 || body.Series[0].Points[1].T != 160000 {
		t.Fatalf("auth series wrong: %+v", body.Series[0])
	}
	if body.Series[1].Service != "payments" || body.Series[1].Points[0].V != 9 {
		t.Fatalf("payments series wrong: %+v", body.Series[1])
	}
}

func TestEmptyResultsAreJSONArraysNotNull(t *testing.T) {
	db := &fakeDB{rows: `[]`}
	rec := call(t, db, "/api/timeseries?metric=nope")
	if !strings.Contains(rec.Body.String(), `"series":[]`) {
		t.Fatalf("frontend expects an empty array, got %s", rec.Body.String())
	}
}
