#/bin/bash

echo "
USE sql_playground;

SELECT 
    CONCAT_WS(\" \", \"Name: \", LOWER(firstname)) as concat_name, UPPER(email), LENGTH(email)
FROM 
    userprofile    
limit 100;" | \
mysql -uroot -ppass -h127.0.0.1 -P3325
