package main

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/jackc/pgx/v5/pgconn"
)

type fakeStore struct {
	searchErr error
	lastLimit int
	added     []string
}

func (f *fakeStore) Search(ctx context.Context, q string, limit int) ([]Article, error) {
	f.lastLimit = limit
	return []Article{{ID: 1, Title: "t", Score: 2, Relative: 1}}, f.searchErr
}

func (f *fakeStore) Count(ctx context.Context, q string) (int64, error) { return 1, nil }

func (f *fakeStore) Tokenize(ctx context.Context, text string) ([]map[string]any, error) {
	return []map[string]any{{"token": text}}, nil
}

func (f *fakeStore) Add(ctx context.Context, title, category, body string) (int64, error) {
	f.added = append(f.added, category)
	return 7, nil
}

func do(t *testing.T, store searchStore, method, target, body string) *httptest.ResponseRecorder {
	t.Helper()
	req := httptest.NewRequest(method, target, strings.NewReader(body))
	rec := httptest.NewRecorder()
	(&API{store: store}).routes().ServeHTTP(rec, req)
	return rec
}

func TestSearchRejectsEmptyQueryInsteadOfMatchingEverything(t *testing.T) {
	rec := do(t, &fakeStore{}, "GET", "/api/search?q=%20%20", "")
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("blank query must be rejected, got %d", rec.Code)
	}
}

func TestSearchCapsLimitSoOneRequestCannotDumpTheTable(t *testing.T) {
	for _, limit := range []string{"0", "51", "abc", "-1"} {
		rec := do(t, &fakeStore{}, "GET", "/api/search?q=java&limit="+limit, "")
		if rec.Code != http.StatusBadRequest {
			t.Fatalf("limit=%s must be rejected, got %d", limit, rec.Code)
		}
	}
	store := &fakeStore{}
	do(t, store, "GET", "/api/search?q=java", "")
	if store.lastLimit != 10 {
		t.Fatalf("default limit must be 10, got %d", store.lastLimit)
	}
}

func TestTinqlSyntaxErrorIsAClientErrorNotAServerError(t *testing.T) {
	store := &fakeStore{searchErr: &pgconn.PgError{Code: "42601", Message: "TINQL parse error"}}
	rec := do(t, store, "GET", "/api/search?q=%22open", "")
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("bad TINQL must be a 400 so the user can fix the query, got %d", rec.Code)
	}
	if !strings.Contains(rec.Body.String(), "TINQL parse error") {
		t.Fatalf("the parser message must reach the user, got %s", rec.Body.String())
	}
}

func TestDatabaseOutageIsAServerErrorWithoutLeakingDetails(t *testing.T) {
	store := &fakeStore{searchErr: context.DeadlineExceeded}
	rec := do(t, store, "GET", "/api/search?q=java", "")
	if rec.Code != http.StatusInternalServerError {
		t.Fatalf("expected 500, got %d", rec.Code)
	}
	if strings.Contains(rec.Body.String(), "deadline") {
		t.Fatalf("internal error details leaked: %s", rec.Body.String())
	}
}

func TestAddRequiresTitleAndBodyAndDefaultsCategory(t *testing.T) {
	store := &fakeStore{}
	if rec := do(t, store, "POST", "/api/articles", `{"title":"x","body":"  "}`); rec.Code != http.StatusBadRequest {
		t.Fatalf("an empty body cannot be indexed, got %d", rec.Code)
	}
	rec := do(t, store, "POST", "/api/articles", `{"title":"x","body":"hello"}`)
	if rec.Code != http.StatusCreated {
		t.Fatalf("expected 201, got %d", rec.Code)
	}
	var out map[string]int64
	json.Unmarshal(rec.Body.Bytes(), &out)
	if out["id"] != 7 || len(store.added) != 1 || store.added[0] != "misc" {
		t.Fatalf("expected id 7 and category misc, got %v %v", out, store.added)
	}
}

func TestUIIsServedFromTheBackend(t *testing.T) {
	rec := do(t, &fakeStore{}, "GET", "/", "")
	if rec.Code != http.StatusOK || !strings.Contains(rec.Body.String(), "TIN Search") {
		t.Fatalf("index page not served, got %d", rec.Code)
	}
}
