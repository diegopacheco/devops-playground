package main

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestQuerySendsParametersCredentialsAndDecodesDataEnvelope(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		q := r.URL.Query()
		body, _ := io.ReadAll(r.Body)
		if q.Get("param_metric") != "cpu_percent" || q.Get("database") != "observability" || q.Get("default_format") != "JSON" {
			t.Errorf("unexpected query string %s", r.URL.RawQuery)
		}
		if q.Get("output_format_json_quote_64bit_integers") != "0" {
			t.Errorf("64 bit integers must be numbers so they decode into uint64")
		}
		if r.Header.Get("X-ClickHouse-User") != "app" || r.Header.Get("X-ClickHouse-Key") != "secret" {
			t.Errorf("credentials must go in headers, not the url")
		}
		if !strings.Contains(string(body), "{metric:String}") {
			t.Errorf("sql body missing placeholder: %s", body)
		}
		io.WriteString(w, `{"meta":[],"data":[{"metric":"cpu_percent","samples":42}],"rows":1}`)
	}))
	defer server.Close()

	var rows []MetricInfo
	ch := NewClickHouse(server.URL, "observability", "app", "secret")
	if err := ch.Query(context.Background(), "SELECT {metric:String}", map[string]string{"metric": "cpu_percent"}, &rows); err != nil {
		t.Fatal(err)
	}
	if len(rows) != 1 || rows[0].Samples != 42 {
		t.Fatalf("unexpected rows %+v", rows)
	}
}

func TestQueryReturnsClickHouseErrorText(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNotFound)
		io.WriteString(w, "Code: 60. Table observability.metrics does not exist")
	}))
	defer server.Close()

	var rows []MetricInfo
	err := NewClickHouse(server.URL, "observability", "app", "app").Query(context.Background(), "SELECT 1", nil, &rows)
	if err == nil || !strings.Contains(err.Error(), "does not exist") {
		t.Fatalf("expected clickhouse error text, got %v", err)
	}
}
