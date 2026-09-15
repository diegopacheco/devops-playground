package main

import (
	"log"
	"net/http"
	"os"
	"time"
)

func env(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func main() {
	ch := NewClickHouse(
		env("CLICKHOUSE_URL", "http://localhost:8123"),
		env("CLICKHOUSE_DB", "observability"),
		env("CLICKHOUSE_USER", "app"),
		env("CLICKHOUSE_PASSWORD", "app"),
	)
	addr := ":" + env("PORT", "8080")
	server := &http.Server{Addr: addr, Handler: NewAPI(ch).Routes(), ReadHeaderTimeout: 5 * time.Second}
	log.Printf("backend listening on %s", addr)
	log.Fatal(server.ListenAndServe())
}
