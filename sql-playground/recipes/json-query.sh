#/bin/bash

export MYSQL_PWD=pass;

echo "=== Json pretty print"
echo "
USE sql_playground;

SELECT JSON_PRETTY(json) from user_json;
" | \
mysql -uroot -h127.0.0.1 -P3325

echo "=== Get Json and alo size"
echo "
USE sql_playground;

select json, json_storage_size(json) as json_size from user_json;
" | \
mysql -uroot -h127.0.0.1 -P3325

echo "=== Extract Json and Where"
echo "
USE sql_playground;

select JSON_EXTRACT(json,'$[0].dept') as dept 
from user_json where JSON_EXTRACT(json, '$[0].name') = 'Knut';
" | \
mysql -uroot -h127.0.0.1 -P3325
