#/bin/bash

export MYSQL_PWD=pass;

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
mysql -uroot -h127.0.0.1 -P3325
