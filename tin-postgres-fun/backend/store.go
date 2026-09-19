package main

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
)

const (
	markStart = "⟦"
	markEnd   = "⟧"
)

type Article struct {
	ID       int64   `json:"id"`
	Title    string  `json:"title"`
	Category string  `json:"category"`
	Snippet  string  `json:"snippet"`
	Score    float64 `json:"score"`
	Relative float64 `json:"relative"`
}

type Store struct {
	pool *pgxpool.Pool
}

const searchSQL = `
SELECT id, title, category,
       tin.highlight(body, $3, $4) AS snippet,
       tin.score(ctid, dense_ratio => 1.0) AS score
FROM articles
WHERE body ==> $1
ORDER BY score DESC, id
LIMIT $2`

func (s *Store) Search(ctx context.Context, query string, limit int) ([]Article, error) {
	rows, err := s.pool.Query(ctx, searchSQL, query, limit, markStart, markEnd)
	if err != nil {
		return nil, err
	}
	articles, err := pgx.CollectRows(rows, func(row pgx.CollectableRow) (Article, error) {
		var a Article
		err := row.Scan(&a.ID, &a.Title, &a.Category, &a.Snippet, &a.Score)
		return a, err
	})
	if err != nil || len(articles) == 0 || articles[0].Score == 0 {
		return articles, err
	}
	for i := range articles {
		articles[i].Relative = articles[i].Score / articles[0].Score
	}
	return articles, nil
}

func (s *Store) Count(ctx context.Context, query string) (int64, error) {
	var n int64
	err := s.pool.QueryRow(ctx, `SELECT count(*) FROM articles WHERE body ==> $1`, query).Scan(&n)
	return n, err
}

func (s *Store) Tokenize(ctx context.Context, text string) ([]map[string]any, error) {
	rows, err := s.pool.Query(ctx, `SELECT * FROM tin.tokenize($1)`, text)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, pgx.RowToMap)
}

func (s *Store) Add(ctx context.Context, title, category, body string) (int64, error) {
	var id int64
	err := s.pool.QueryRow(ctx,
		`INSERT INTO articles (title, category, body) VALUES ($1, $2, $3) RETURNING id`,
		title, category, body).Scan(&id)
	return id, err
}

func isQueryError(err error) bool {
	var pgErr *pgconn.PgError
	return errors.As(err, &pgErr)
}
