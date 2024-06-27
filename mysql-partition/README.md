### Run
```
./run-mysql-container.sh
```

### Errors

```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->           id INT AUTO_INCREMENT PRIMARY KEY,
    ->           first_name VARCHAR(255) NOT NULL,
    ->           last_name VARCHAR(255) NOT NULL,
    ->           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->           created_year int,
    ->           UNIQUE KEY (id,created_year)
    ->       ) PARTITION BY HASH(created_year);
ERROR 1503 (HY000): A PRIMARY KEY must include all columns in the table's partitioning function
```

