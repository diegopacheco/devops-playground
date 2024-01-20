#/bin/bash

tiv ../images/right-outer-join.png

export MYSQL_PWD=pass;

echo "
USE sql_playground;

SELECT 
    u.*,
    p.*
FROM 
    users u
RIGHT OUTER JOIN userprofile p
ON u.auid = p.auid;" | \
mysql -uroot -h127.0.0.1 -P3325