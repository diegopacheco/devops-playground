package main

import (
	"context"
	"sort"
	"testing"

	"github.com/jackc/pgx/v5/pgxpool"
)

func testStore(t *testing.T) *Store {
	t.Helper()
	pool, err := pgxpool.New(context.Background(), env("DATABASE_URL", "postgresql://tin:tin@localhost:5432/search"))
	if err != nil {
		t.Fatalf("database config: %v", err)
	}
	if err := pool.Ping(context.Background()); err != nil {
		t.Fatalf("postgres with the tin extension must be running, start it with ./scripts/start-all.sh: %v", err)
	}
	t.Cleanup(pool.Close)
	return &Store{pool: pool}
}

func titles(t *testing.T, s *Store, q string) []string {
	t.Helper()
	res, err := s.Search(context.Background(), q, 50)
	if err != nil {
		t.Fatalf("search %q: %v", q, err)
	}
	out := make([]string, len(res))
	for i, a := range res {
		out[i] = a.Title
	}
	sort.Strings(out)
	return out
}

func count(t *testing.T, s *Store, q string) int64 {
	t.Helper()
	n, err := s.Count(context.Background(), q)
	if err != nil {
		t.Fatalf("count %q: %v", q, err)
	}
	return n
}

func contains(list []string, v string) bool {
	for _, x := range list {
		if x == v {
			return true
		}
	}
	return false
}

func TestBooleanNotSeparatesJavaTheLanguageFromTheIslandAndCoffee(t *testing.T) {
	s := testStore(t)
	all := titles(t, s, "java")
	lang := titles(t, s, "java AND NOT [island coffee indonesia]")
	if !contains(all, "Visiting Java island") || !contains(all, "Java coffee tasting notes") {
		t.Fatalf("plain java must find the island and the coffee too, got %v", all)
	}
	if contains(lang, "Visiting Java island") || contains(lang, "Java coffee tasting notes") {
		t.Fatalf("NOT must exclude the island and the coffee, got %v", lang)
	}
	if len(lang) != 3 {
		t.Fatalf("expected the 3 programming articles, got %v", lang)
	}
}

func TestAccentAndCaseFoldingLetUsersTypePlainAscii(t *testing.T) {
	s := testStore(t)
	if got := titles(t, s, "jalapeno"); !contains(got, "Jalapeño poppers") {
		t.Fatalf("jalapeno must match Jalapeño, got %v", got)
	}
	if got := titles(t, s, "CREME brulee"); !contains(got, "Crème brûlée at home") {
		t.Fatalf("CREME brulee must match Crème brûlée, got %v", got)
	}
}

func TestFuzzyMatchingForgivesTypos(t *testing.T) {
	s := testStore(t)
	if n := count(t, s, "vulnerabilty"); n != 0 {
		t.Fatalf("the misspelled term alone must match nothing, got %d", n)
	}
	if n := count(t, s, "vulnerabilty~2"); n < 3 {
		t.Fatalf("fuzzy ~2 must recover the vulnerability articles, got %d", n)
	}
}

func TestWildcardExpandsToEveryFormOfTheWord(t *testing.T) {
	s := testStore(t)
	got := titles(t, s, "brew*")
	for _, want := range []string{"Home brewing an IPA", "Belgian brewery tour"} {
		if !contains(got, want) {
			t.Fatalf("brew* must match %q, got %v", want, got)
		}
	}
}

func TestOrderedOperatorsCareAboutWordOrderAndConjunctionDoesNot(t *testing.T) {
	s := testStore(t)
	if n := count(t, s, "methods AND results"); n != 2 {
		t.Fatalf("both research articles mention methods and results, got %d", n)
	}
	got := titles(t, s, "methods BEFORE results")
	if len(got) != 1 || got[0] != "Methods and results of a caching study" {
		t.Fatalf("only the article with methods before results must match, got %v", got)
	}
}

func TestPhraseRequiresAdjacentWords(t *testing.T) {
	s := testStore(t)
	if n := count(t, s, `"threads virtual"`); n != 0 {
		t.Fatalf("reversed phrase must not match, got %d", n)
	}
	if got := titles(t, s, `"virtual threads"`); len(got) != 1 {
		t.Fatalf("exact phrase must match one article, got %v", got)
	}
}

func TestNotEnclosesDropsSalesPitchesFromSecuritySearch(t *testing.T) {
	s := testStore(t)
	broad := titles(t, s, "security NEAR/5 [threat vulnerability risk]")
	clean := titles(t, s, "security NEAR/5 [threat vulnerability risk] NOT ENCLOSES [buy pricing discount subscription]")
	if !contains(broad, "Security scanner pricing") {
		t.Fatalf("the ad mentions security near vulnerability and must match the broad query, got %v", broad)
	}
	if contains(clean, "Security scanner pricing") || len(clean) == 0 {
		t.Fatalf("NOT ENCLOSES must drop only the ad, got %v", clean)
	}
}

func TestResultsAreRankedByBM25WithTheBestMatchFirst(t *testing.T) {
	s := testStore(t)
	res, err := s.Search(context.Background(), "yeast OR hops", 10)
	if err != nil {
		t.Fatal(err)
	}
	if len(res) < 3 {
		t.Fatalf("expected several beer articles, got %d", len(res))
	}
	for i := 1; i < len(res); i++ {
		if res[i].Score > res[i-1].Score {
			t.Fatalf("results must be sorted by score desc: %v", res)
		}
	}
	if res[0].Relative != 1 {
		t.Fatalf("the top result defines max_score so its relative score must be 1, got %v", res[0].Relative)
	}
	if res[0].Snippet == "" {
		t.Fatalf("results must carry a highlighted snippet")
	}
}

func TestNewArticlesAreSearchableAfterCommitAndInvisibleBefore(t *testing.T) {
	s := testStore(t)
	ctx := context.Background()
	term := "zyxwquartzoid"

	tx, err := s.pool.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback(ctx)
	var id int64
	if err := tx.QueryRow(ctx, `INSERT INTO articles (title, category, body) VALUES ('mvcc', 'test', $1) RETURNING id`,
		"a note about "+term).Scan(&id); err != nil {
		t.Fatal(err)
	}
	if n := count(t, s, term); n != 0 {
		t.Fatalf("an uncommitted row must be invisible to other sessions, got %d", n)
	}
	if err := tx.Commit(ctx); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { s.pool.Exec(ctx, `DELETE FROM articles WHERE id = $1`, id) })
	if n := count(t, s, term); n != 1 {
		t.Fatalf("a committed row must be searchable right away, got %d", n)
	}
}

func TestMalformedTinqlIsReportedAsAQueryError(t *testing.T) {
	s := testStore(t)
	_, err := s.Search(context.Background(), `"unclosed phrase`, 5)
	if err == nil || !isQueryError(err) {
		t.Fatalf("expected a postgres query error, got %v", err)
	}
}

func TestRelativeScoreIsNormalizedAgainstTheBestMatch(t *testing.T) {
	s := testStore(t)
	for _, q := range []string{
		"java AND NOT [island coffee indonesia]",
		"security NEAR/5 [threat vulnerability risk] NOT ENCLOSES [buy pricing discount]",
		"yeast OR hops",
	} {
		res, err := s.Search(context.Background(), q, 10)
		if err != nil {
			t.Fatalf("search %q: %v", q, err)
		}
		if len(res) == 0 || res[0].Relative != 1 {
			t.Fatalf("%q: the best match must be at 100%%, got %v", q, res)
		}
		for _, a := range res {
			if a.Relative < 0 || a.Relative > 1 {
				t.Fatalf("%q: relative score must stay within 0..1, got %v for %q", q, a.Relative, a.Title)
			}
		}
	}
}

func TestWildcardOnlyMatchesDoNotBreakScoring(t *testing.T) {
	s := testStore(t)
	res, err := s.Search(context.Background(), "brew*", 10)
	if err != nil {
		t.Fatalf("wildcard terms carry no BM25 weight and must not cause a division by zero: %v", err)
	}
	for _, a := range res {
		if a.Relative != 0 {
			t.Fatalf("with no scored terms every relative score must be 0, got %v", a.Relative)
		}
	}
}
