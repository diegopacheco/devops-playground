-- name: get_user_total_spent
SELECT u.name, SUM(o.amount) as total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC;
