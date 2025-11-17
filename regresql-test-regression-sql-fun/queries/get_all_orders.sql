-- name: get_all_orders
SELECT o.id, u.name as user_name, o.product, o.amount, o.status
FROM orders o
JOIN users u ON o.user_id = u.id
ORDER BY o.id;
