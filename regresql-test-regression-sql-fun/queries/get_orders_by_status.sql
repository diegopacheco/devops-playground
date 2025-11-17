-- name: get_orders_by_status
SELECT o.id, u.name as user_name, o.product, o.amount
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = :status
ORDER BY o.id;
