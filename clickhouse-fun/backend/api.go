package main

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"strconv"
)

type Querier interface {
	Query(ctx context.Context, sql string, params map[string]string, out any) error
}

type API struct {
	db Querier
}

type Stats struct {
	Rows              uint64 `json:"rows"`
	FirstTs           string `json:"first_ts"`
	LastTs            string `json:"last_ts"`
	CompressedBytes   uint64 `json:"compressed_bytes"`
	UncompressedBytes uint64 `json:"uncompressed_bytes"`
	Parts             uint64 `json:"parts"`
}

type MetricInfo struct {
	Metric   string `json:"metric"`
	Samples  uint64 `json:"samples"`
	Services uint64 `json:"services"`
}

type Summary struct {
	Metric  string  `json:"metric"`
	Samples uint64  `json:"samples"`
	Avg     float64 `json:"avg"`
	Min     float64 `json:"min"`
	Max     float64 `json:"max"`
	P95     float64 `json:"p95"`
}

type Point struct {
	T int64   `json:"t"`
	V float64 `json:"v"`
}

type Series struct {
	Service string  `json:"service"`
	Points  []Point `json:"points"`
}

type Timeseries struct {
	Metric  string   `json:"metric"`
	Minutes int      `json:"minutes"`
	Step    int      `json:"step"`
	Series  []Series `json:"series"`
}

type TopService struct {
	Service string  `json:"service"`
	Avg     float64 `json:"avg"`
	P95     float64 `json:"p95"`
	Max     float64 `json:"max"`
	Samples uint64  `json:"samples"`
}

type seriesRow struct {
	Service string  `json:"service"`
	T       int64   `json:"t"`
	V       float64 `json:"v"`
}

func NewAPI(db Querier) *API {
	return &API{db: db}
}

func (a *API) Routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /api/health", a.health)
	mux.HandleFunc("GET /api/stats", a.stats)
	mux.HandleFunc("GET /api/metrics", a.metrics)
	mux.HandleFunc("GET /api/summary", a.summary)
	mux.HandleFunc("GET /api/timeseries", a.timeseries)
	mux.HandleFunc("GET /api/top", a.top)
	return mux
}

func (a *API) health(w http.ResponseWriter, r *http.Request) {
	var rows []struct {
		Ok uint8 `json:"ok"`
	}
	if err := a.db.Query(r.Context(), "SELECT 1 AS ok", nil, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "up"})
}

func (a *API) stats(w http.ResponseWriter, r *http.Request) {
	var rows []Stats
	if err := a.db.Query(r.Context(), statsSQL, nil, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	if len(rows) == 0 {
		writeJSON(w, http.StatusOK, Stats{})
		return
	}
	writeJSON(w, http.StatusOK, rows[0])
}

func (a *API) metrics(w http.ResponseWriter, r *http.Request) {
	rows := []MetricInfo{}
	if err := a.db.Query(r.Context(), metricsSQL, nil, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, rows)
}

func (a *API) summary(w http.ResponseWriter, r *http.Request) {
	minutes, err := parseMinutes(r.URL.Query().Get("minutes"))
	if err != nil {
		badRequest(w, err)
		return
	}
	rows := []Summary{}
	if err := a.db.Query(r.Context(), summarySQL, map[string]string{"minutes": strconv.Itoa(minutes)}, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, rows)
}

func (a *API) timeseries(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	metric, err := parseMetric(q.Get("metric"))
	if err != nil {
		badRequest(w, err)
		return
	}
	minutes, err := parseMinutes(q.Get("minutes"))
	if err != nil {
		badRequest(w, err)
		return
	}
	step := stepFor(minutes)
	var rows []seriesRow
	params := map[string]string{"metric": metric, "minutes": strconv.Itoa(minutes), "step": strconv.Itoa(step)}
	if err := a.db.Query(r.Context(), timeseriesSQL, params, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, Timeseries{Metric: metric, Minutes: minutes, Step: step, Series: groupSeries(rows)})
}

func (a *API) top(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	metric, err := parseMetric(q.Get("metric"))
	if err != nil {
		badRequest(w, err)
		return
	}
	minutes, err := parseMinutes(q.Get("minutes"))
	if err != nil {
		badRequest(w, err)
		return
	}
	limit, err := parseLimit(q.Get("limit"))
	if err != nil {
		badRequest(w, err)
		return
	}
	rows := []TopService{}
	params := map[string]string{"metric": metric, "minutes": strconv.Itoa(minutes), "limit": strconv.Itoa(limit)}
	if err := a.db.Query(r.Context(), topSQL, params, &rows); err != nil {
		upstreamError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, rows)
}

func parseMinutes(raw string) (int, error) {
	return parseBounded(raw, 60, 1, 1440, "minutes")
}

func parseLimit(raw string) (int, error) {
	return parseBounded(raw, 5, 1, 50, "limit")
}

func parseBounded(raw string, fallback, min, max int, name string) (int, error) {
	if raw == "" {
		return fallback, nil
	}
	n, err := strconv.Atoi(raw)
	if err != nil || n < min || n > max {
		return 0, errors.New(name + " must be an integer between " + strconv.Itoa(min) + " and " + strconv.Itoa(max))
	}
	return n, nil
}

func parseMetric(raw string) (string, error) {
	if raw == "" {
		return "", errors.New("metric is required")
	}
	if len(raw) > 64 {
		return "", errors.New("metric must be at most 64 characters")
	}
	return raw, nil
}

func stepFor(minutes int) int {
	return max(10, minutes)
}

func groupSeries(rows []seriesRow) []Series {
	series := []Series{}
	for _, row := range rows {
		if len(series) == 0 || series[len(series)-1].Service != row.Service {
			series = append(series, Series{Service: row.Service, Points: []Point{}})
		}
		last := &series[len(series)-1]
		last.Points = append(last.Points, Point{T: row.T * 1000, V: row.V})
	}
	return series
}

func writeJSON(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(body)
}

func badRequest(w http.ResponseWriter, err error) {
	writeJSON(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
}

func upstreamError(w http.ResponseWriter, err error) {
	log.Printf("clickhouse query failed: %v", err)
	writeJSON(w, http.StatusBadGateway, map[string]string{"error": "clickhouse query failed"})
}
