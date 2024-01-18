#/bin/bash

tiv ../images/right-outer-join.png

echo "
USE sql_playground;

SELECT 
    u.*,
    p.*
FROM 
    users u
RIGHT OUTER JOIN userprofile p
ON u.auid = p.auid;" | \
mysql -uroot -ppass -h127.0.0.1 -P3325