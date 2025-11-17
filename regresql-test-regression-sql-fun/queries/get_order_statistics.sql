-- name: get_order_statistics
SELECT
    status,
    COUNT(*) as order_count,
    SUM(amount) as total_amount,
    AVG(amount) as avg_amount
FROM orders
GROUP BY status
ORDER BY status;
