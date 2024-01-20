#/bin/bash

export MYSQL_PWD=pass;

echo "
USE sql_playground;

SELECT firstname, email,
CASE 
  WHEN email like 'b%' THEN \"COOL\"
  ELSE \"MEH\"
END AS status
FROM userprofile;" | \
mysql -uroot -h127.0.0.1 -P3325
