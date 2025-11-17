CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    age INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    product VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, age) VALUES
    ('Alice Smith', 'alice@test.com', 30),
    ('Bob Jones', 'bob@test.com', 25),
    ('Carol White', 'carol@test.com', 35),
    ('David Brown', 'david@test.com', 28),
    ('Eve Black', 'eve@test.com', 32);

INSERT INTO orders (user_id, product, amount, status) VALUES
    (1, 'Laptop', 1200.00, 'completed'),
    (1, 'Mouse', 25.00, 'completed'),
    (2, 'Keyboard', 75.00, 'pending'),
    (3, 'Monitor', 350.00, 'completed'),
    (4, 'Headphones', 150.00, 'shipped'),
    (5, 'Webcam', 80.00, 'pending'),
    (1, 'USB Hub', 45.00, 'completed'),
    (3, 'Desk Chair', 299.00, 'completed');
