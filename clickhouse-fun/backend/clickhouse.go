package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

type ClickHouse struct {
	baseURL  string
	database string
	user     string
	password string
	client   *http.Client
}

func NewClickHouse(baseURL, database, user, password string) *ClickHouse {
	return &ClickHouse{
		baseURL:  strings.TrimRight(baseURL, "/"),
		database: database,
		user:     user,
		password: password,
		client:   &http.Client{Timeout: 10 * time.Second},
	}
}

func (c *ClickHouse) Query(ctx context.Context, sql string, params map[string]string, out any) error {
	q := url.Values{}
	q.Set("database", c.database)
	q.Set("default_format", "JSON")
	q.Set("output_format_json_quote_64bit_integers", "0")
	for k, v := range params {
		q.Set("param_"+k, v)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/?"+q.Encode(), strings.NewReader(sql))
	if err != nil {
		return err
	}
	req.Header.Set("X-ClickHouse-User", c.user)
	req.Header.Set("X-ClickHouse-Key", c.password)
	resp, err := c.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 2048))
		return fmt.Errorf("clickhouse returned %d: %s", resp.StatusCode, strings.TrimSpace(string(body)))
	}
	var envelope struct {
		Data json.RawMessage `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&envelope); err != nil {
		return err
	}
	return json.Unmarshal(envelope.Data, out)
}
