package main

import (
	"context"
	"log"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

func env(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func main() {
	dsn := env("DATABASE_URL", "postgresql://tin:tin@localhost:5432/search")
	port := env("PORT", "8095")

	pool, err := pgxpool.New(context.Background(), dsn)
	if err != nil {
		log.Fatalf("database config: %v", err)
	}
	defer pool.Close()
	if err := pool.Ping(context.Background()); err != nil {
		log.Fatalf("database ping: %v", err)
	}

	api := &API{store: &Store{pool: pool}}
	log.Printf("listening on :%s", port)
	log.Fatal(http.ListenAndServe(":"+port, api.routes()))
}
