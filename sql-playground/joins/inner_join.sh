#!/bin/bash

echo "
USE sql_playground;

SELECT 
    u.*,
    p.*
FROM 
    users u
INNER JOIN userprofile p
ON u.auid = p.auid;" | \
mysql -uroot -ppass -h127.0.0.1 -P3325