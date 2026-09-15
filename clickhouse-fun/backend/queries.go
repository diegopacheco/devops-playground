package main

const windowStart = "(SELECT max(ts) FROM metrics) - toIntervalMinute({minutes:UInt32})"

const statsSQL = `
SELECT
    (SELECT count() FROM metrics) AS rows,
    (SELECT toString(min(ts)) FROM metrics) AS first_ts,
    (SELECT toString(max(ts)) FROM metrics) AS last_ts,
    sum(data_compressed_bytes) AS compressed_bytes,
    sum(data_uncompressed_bytes) AS uncompressed_bytes,
    count() AS parts
FROM system.parts
WHERE active AND database = currentDatabase() AND table = 'metrics'`

const metricsSQL = `
SELECT metric, count() AS samples, uniqExact(service) AS services
FROM metrics
GROUP BY metric
ORDER BY metric`

const summarySQL = `
SELECT
    metric,
    count() AS samples,
    round(avg(value), 2) AS avg,
    round(min(value), 2) AS min,
    round(max(value), 2) AS max,
    round(quantile(0.95)(value), 2) AS p95
FROM metrics
WHERE ts > ` + windowStart + `
GROUP BY metric
ORDER BY metric`

const timeseriesSQL = `
SELECT
    service,
    toUnixTimestamp(toStartOfInterval(toDateTime(ts), toIntervalSecond({step:UInt32}))) AS t,
    round(avg(value), 2) AS v
FROM metrics
WHERE metric = {metric:String} AND ts > ` + windowStart + `
GROUP BY service, t
ORDER BY service, t`

const topSQL = `
SELECT
    service,
    round(avg(value), 2) AS avg,
    round(quantile(0.95)(value), 2) AS p95,
    round(max(value), 2) AS max,
    count() AS samples
FROM metrics
WHERE metric = {metric:String} AND ts > ` + windowStart + `
GROUP BY service
ORDER BY p95 DESC
LIMIT {limit:UInt32}`
