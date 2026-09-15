CREATE TABLE IF NOT EXISTS observability.metrics
(
    ts DateTime64(3),
    service LowCardinality(String),
    host LowCardinality(String),
    metric LowCardinality(String),
    value Float64
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(ts)
ORDER BY (metric, service, host, ts)
TTL toDateTime(ts) + INTERVAL 30 DAY;
