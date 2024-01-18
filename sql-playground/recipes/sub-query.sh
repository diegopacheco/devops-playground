#/bin/bash

echo "
USE sql_playground;

SELECT 
    firstname, email
FROM
    userprofile
WHERE
    auid IN (SELECT 
            auid
        FROM
            userprofile
        WHERE
            email like 'b%');" | \
mysql -uroot -ppass -h127.0.0.1 -P3325
