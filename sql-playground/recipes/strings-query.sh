#/bin/bash

export MYSQL_PWD=pass;

echo "
USE sql_playground;

SELECT 
    CONCAT_WS(\" \", \"Name: \", LOWER(firstname)) as concat_name, UPPER(email), LENGTH(email)
FROM 
    userprofile    
limit 100;" | \
mysql -uroot -h127.0.0.1 -P3325
