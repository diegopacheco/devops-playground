-- name: get_user_by_id
SELECT id, name, email, age FROM users WHERE id = :id;
