#/bin/bash

echo "
USE sql_playground;

SELECT firstname, email,
CASE 
  WHEN email like 'b%' THEN \"COOL\"
  ELSE \"MEH\"
END AS status
FROM userprofile;" | \
mysql -uroot -ppass -h127.0.0.1 -P3325
