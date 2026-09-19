package main

import (
	"context"
	"embed"
	"encoding/json"
	"io/fs"
	"log"
	"net/http"
	"strconv"
	"strings"
)

//go:embed static
var staticFiles embed.FS

type searchStore interface {
	Search(ctx context.Context, query string, limit int) ([]Article, error)
	Count(ctx context.Context, query string) (int64, error)
	Tokenize(ctx context.Context, text string) ([]map[string]any, error)
	Add(ctx context.Context, title, category, body string) (int64, error)
}

type API struct {
	store searchStore
}

type newArticle struct {
	Title    string `json:"title"`
	Category string `json:"category"`
	Body     string `json:"body"`
}

func (a *API) routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /api/health", a.health)
	mux.HandleFunc("GET /api/search", a.search)
	mux.HandleFunc("GET /api/count", a.count)
	mux.HandleFunc("GET /api/tokenize", a.tokenize)
	mux.HandleFunc("POST /api/articles", a.add)
	static, _ := fs.Sub(staticFiles, "static")
	mux.Handle("GET /", http.FileServerFS(static))
	return mux
}

func (a *API) health(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func (a *API) search(w http.ResponseWriter, r *http.Request) {
	q := strings.TrimSpace(r.URL.Query().Get("q"))
	if q == "" {
		writeError(w, http.StatusBadRequest, "q is required")
		return
	}
	limit, ok := parseLimit(r.URL.Query().Get("limit"))
	if !ok {
		writeError(w, http.StatusBadRequest, "limit must be between 1 and 50")
		return
	}
	articles, err := a.store.Search(r.Context(), q, limit)
	if err != nil {
		writeStoreError(w, err)
		return
	}
	total, err := a.store.Count(r.Context(), q)
	if err != nil {
		writeStoreError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"query": q, "total": total, "results": articles})
}

func (a *API) count(w http.ResponseWriter, r *http.Request) {
	q := strings.TrimSpace(r.URL.Query().Get("q"))
	if q == "" {
		writeError(w, http.StatusBadRequest, "q is required")
		return
	}
	total, err := a.store.Count(r.Context(), q)
	if err != nil {
		writeStoreError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"query": q, "total": total})
}

func (a *API) tokenize(w http.ResponseWriter, r *http.Request) {
	text := r.URL.Query().Get("text")
	if strings.TrimSpace(text) == "" {
		writeError(w, http.StatusBadRequest, "text is required")
		return
	}
	tokens, err := a.store.Tokenize(r.Context(), text)
	if err != nil {
		writeStoreError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"text": text, "tokens": tokens})
}

func (a *API) add(w http.ResponseWriter, r *http.Request) {
	var in newArticle
	if err := json.NewDecoder(http.MaxBytesReader(w, r.Body, 1<<20)).Decode(&in); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json body")
		return
	}
	in.Title = strings.TrimSpace(in.Title)
	in.Category = strings.TrimSpace(in.Category)
	in.Body = strings.TrimSpace(in.Body)
	if in.Title == "" || in.Body == "" {
		writeError(w, http.StatusBadRequest, "title and body are required")
		return
	}
	if in.Category == "" {
		in.Category = "misc"
	}
	id, err := a.store.Add(r.Context(), in.Title, in.Category, in.Body)
	if err != nil {
		writeStoreError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, map[string]int64{"id": id})
}

func parseLimit(raw string) (int, bool) {
	if raw == "" {
		return 10, true
	}
	n, err := strconv.Atoi(raw)
	if err != nil || n < 1 || n > 50 {
		return 0, false
	}
	return n, true
}

func writeStoreError(w http.ResponseWriter, err error) {
	if isQueryError(err) {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	log.Printf("store error: %v", err)
	writeError(w, http.StatusInternalServerError, "database unavailable")
}

func writeError(w http.ResponseWriter, status int, msg string) {
	writeJSON(w, status, map[string]string{"error": msg})
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}
