#!/bin/bash

echo "=========================================="
echo "EVIDENCE SCRIPT: USER_HASH PARTITIONING"
echo "=========================================="

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="partitions_db"
DB_USER="postgres"
PGPASSWORD="postgres"

export PGPASSWORD

echo ""
echo "1. PROVING PARTITIONS EXIST FOR HASH STRATEGY"
echo "----------------------------------------------"

echo ""
echo "1.1 List all partitions for user_hash_v1 (explicit partition key - hash_key):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_hash_v1_p%'
ORDER BY tablename;
"

echo ""
echo "1.2 List all partitions for user_hash_v2 (derived partition key - username):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_hash_v2_p%'
ORDER BY tablename;
"

echo ""
echo "1.3 Show partition information from pg_partitions:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    schemaname,
    tablename as parent_table,
    partitionschemaname,
    partitiontablename
FROM pg_partitions 
WHERE tablename IN ('user_hash_v1', 'user_hash_v2')
ORDER BY tablename, partitiontablename;
"

echo ""
echo "1.4 Count records per partition for user_hash_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_hash_v1_p0' as partition, COUNT(*) as record_count FROM user_hash_v1_p0
UNION ALL SELECT 'user_hash_v1_p1', COUNT(*) FROM user_hash_v1_p1
UNION ALL SELECT 'user_hash_v1_p2', COUNT(*) FROM user_hash_v1_p2
UNION ALL SELECT 'user_hash_v1_p3', COUNT(*) FROM user_hash_v1_p3
UNION ALL SELECT 'user_hash_v1_p4', COUNT(*) FROM user_hash_v1_p4
UNION ALL SELECT 'user_hash_v1_p5', COUNT(*) FROM user_hash_v1_p5
UNION ALL SELECT 'user_hash_v1_p6', COUNT(*) FROM user_hash_v1_p6
UNION ALL SELECT 'user_hash_v1_p7', COUNT(*) FROM user_hash_v1_p7
UNION ALL SELECT 'user_hash_v1_p8', COUNT(*) FROM user_hash_v1_p8
UNION ALL SELECT 'user_hash_v1_p9', COUNT(*) FROM user_hash_v1_p9
UNION ALL SELECT 'user_hash_v1_p10', COUNT(*) FROM user_hash_v1_p10
UNION ALL SELECT 'user_hash_v1_p11', COUNT(*) FROM user_hash_v1_p11
UNION ALL SELECT 'user_hash_v1_p12', COUNT(*) FROM user_hash_v1_p12
UNION ALL SELECT 'user_hash_v1_p13', COUNT(*) FROM user_hash_v1_p13
UNION ALL SELECT 'user_hash_v1_p14', COUNT(*) FROM user_hash_v1_p14
UNION ALL SELECT 'user_hash_v1_p15', COUNT(*) FROM user_hash_v1_p15
UNION ALL SELECT 'user_hash_v1_p16', COUNT(*) FROM user_hash_v1_p16
UNION ALL SELECT 'user_hash_v1_p17', COUNT(*) FROM user_hash_v1_p17
UNION ALL SELECT 'user_hash_v1_p18', COUNT(*) FROM user_hash_v1_p18
UNION ALL SELECT 'user_hash_v1_p19', COUNT(*) FROM user_hash_v1_p19
UNION ALL SELECT 'user_hash_v1_p20', COUNT(*) FROM user_hash_v1_p20
UNION ALL SELECT 'user_hash_v1_p21', COUNT(*) FROM user_hash_v1_p21
UNION ALL SELECT 'user_hash_v1_p22', COUNT(*) FROM user_hash_v1_p22
UNION ALL SELECT 'user_hash_v1_p23', COUNT(*) FROM user_hash_v1_p23
UNION ALL SELECT 'user_hash_v1_p24', COUNT(*) FROM user_hash_v1_p24
UNION ALL SELECT 'user_hash_v1_p25', COUNT(*) FROM user_hash_v1_p25
UNION ALL SELECT 'user_hash_v1_p26', COUNT(*) FROM user_hash_v1_p26
ORDER BY partition;
"

echo ""
echo "1.5 Count records per partition for user_hash_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_hash_v2_p0' as partition, COUNT(*) as record_count FROM user_hash_v2_p0
UNION ALL SELECT 'user_hash_v2_p1', COUNT(*) FROM user_hash_v2_p1
UNION ALL SELECT 'user_hash_v2_p2', COUNT(*) FROM user_hash_v2_p2
UNION ALL SELECT 'user_hash_v2_p3', COUNT(*) FROM user_hash_v2_p3
UNION ALL SELECT 'user_hash_v2_p4', COUNT(*) FROM user_hash_v2_p4
UNION ALL SELECT 'user_hash_v2_p5', COUNT(*) FROM user_hash_v2_p5
UNION ALL SELECT 'user_hash_v2_p6', COUNT(*) FROM user_hash_v2_p6
UNION ALL SELECT 'user_hash_v2_p7', COUNT(*) FROM user_hash_v2_p7
UNION ALL SELECT 'user_hash_v2_p8', COUNT(*) FROM user_hash_v2_p8
UNION ALL SELECT 'user_hash_v2_p9', COUNT(*) FROM user_hash_v2_p9
UNION ALL SELECT 'user_hash_v2_p10', COUNT(*) FROM user_hash_v2_p10
UNION ALL SELECT 'user_hash_v2_p11', COUNT(*) FROM user_hash_v2_p11
UNION ALL SELECT 'user_hash_v2_p12', COUNT(*) FROM user_hash_v2_p12
UNION ALL SELECT 'user_hash_v2_p13', COUNT(*) FROM user_hash_v2_p13
UNION ALL SELECT 'user_hash_v2_p14', COUNT(*) FROM user_hash_v2_p14
UNION ALL SELECT 'user_hash_v2_p15', COUNT(*) FROM user_hash_v2_p15
UNION ALL SELECT 'user_hash_v2_p16', COUNT(*) FROM user_hash_v2_p16
UNION ALL SELECT 'user_hash_v2_p17', COUNT(*) FROM user_hash_v2_p17
UNION ALL SELECT 'user_hash_v2_p18', COUNT(*) FROM user_hash_v2_p18
UNION ALL SELECT 'user_hash_v2_p19', COUNT(*) FROM user_hash_v2_p19
UNION ALL SELECT 'user_hash_v2_p20', COUNT(*) FROM user_hash_v2_p20
UNION ALL SELECT 'user_hash_v2_p21', COUNT(*) FROM user_hash_v2_p21
UNION ALL SELECT 'user_hash_v2_p22', COUNT(*) FROM user_hash_v2_p22
UNION ALL SELECT 'user_hash_v2_p23', COUNT(*) FROM user_hash_v2_p23
UNION ALL SELECT 'user_hash_v2_p24', COUNT(*) FROM user_hash_v2_p24
UNION ALL SELECT 'user_hash_v2_p25', COUNT(*) FROM user_hash_v2_p25
UNION ALL SELECT 'user_hash_v2_p26', COUNT(*) FROM user_hash_v2_p26
ORDER BY partition;
"

echo ""
echo "=========================================="
echo "2. PERFORMANCE TESTING WITH TIMING"
echo "=========================================="

echo ""
echo "2.1 USER_HASH_V1 TESTS (Explicit Partition Key - hash_key)"
echo "-----------------------------------------------------------"

echo ""
echo "2.1.1 Query WITH partition key (hash_key = 150) - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_hash_v1 WHERE hash_key = 150;
"

echo ""
echo "2.1.2 Query WITHOUT partition key (username LIKE pattern) - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_hash_v1 WHERE username LIKE 'user_hash_15%';
"

echo ""
echo "2.1.3 Query WITH partition key (multiple specific values) - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_hash_v1 WHERE hash_key IN (100, 200, 300);
"

echo ""
echo "2.1.4 Aggregate query WITHOUT partition key - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_hash_v1 WHERE email LIKE '%example.com';
"

echo ""
echo "2.2 USER_HASH_V2 TESTS (Derived Partition Key - username)"
echo "----------------------------------------------------------"

echo ""
echo "2.2.1 Query WITH partition key (username = 'user_hash_v2_150') - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_hash_v2 WHERE username = 'user_hash_v2_150';
"

echo ""
echo "2.2.2 Query WITH partition key (multiple specific usernames) - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_hash_v2 WHERE username IN ('user_hash_v2_100', 'user_hash_v2_200', 'user_hash_v2_300');
"

echo ""
echo "2.2.3 Query WITHOUT partition key (user_id range) - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_hash_v2 WHERE user_id BETWEEN 100 AND 200;
"

echo ""
echo "2.2.4 Aggregate query WITHOUT partition key - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_hash_v2 WHERE email LIKE '%example.com';
"

echo ""
echo "=========================================="
echo "3. PARTITION PRUNING DEMONSTRATION"
echo "=========================================="

echo ""
echo "3.1 Show partition pruning for user_hash_v1 (equality):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_hash_v1 WHERE hash_key = 555;
"

echo ""
echo "3.2 Show partition pruning for user_hash_v2 (equality):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_hash_v2 WHERE username = 'user_hash_v2_555';
"

echo ""
echo "3.3 Show limited partition pruning for user_hash_v1 (IN clause):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_hash_v1 WHERE hash_key IN (111, 222, 333);
"

echo ""
echo "3.4 Show full table scan (no partition pruning):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT COUNT(*) FROM user_hash_v1 WHERE username LIKE '%hash%';
"

echo ""
echo "=========================================="
echo "4. HASH-SPECIFIC DEMONSTRATIONS"
echo "=========================================="

echo ""
echo "4.1 Show data distribution across hash partitions for user_hash_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
WITH partition_counts AS (
    SELECT 'p0' as partition, COUNT(*) as count FROM user_hash_v1_p0
    UNION ALL SELECT 'p1', COUNT(*) FROM user_hash_v1_p1
    UNION ALL SELECT 'p2', COUNT(*) FROM user_hash_v1_p2
    UNION ALL SELECT 'p3', COUNT(*) FROM user_hash_v1_p3
    UNION ALL SELECT 'p4', COUNT(*) FROM user_hash_v1_p4
    UNION ALL SELECT 'p5', COUNT(*) FROM user_hash_v1_p5
    UNION ALL SELECT 'p6', COUNT(*) FROM user_hash_v1_p6
    UNION ALL SELECT 'p7', COUNT(*) FROM user_hash_v1_p7
    UNION ALL SELECT 'p8', COUNT(*) FROM user_hash_v1_p8
    UNION ALL SELECT 'p9', COUNT(*) FROM user_hash_v1_p9
    UNION ALL SELECT 'p10', COUNT(*) FROM user_hash_v1_p10
    UNION ALL SELECT 'p11', COUNT(*) FROM user_hash_v1_p11
    UNION ALL SELECT 'p12', COUNT(*) FROM user_hash_v1_p12
    UNION ALL SELECT 'p13', COUNT(*) FROM user_hash_v1_p13
    UNION ALL SELECT 'p14', COUNT(*) FROM user_hash_v1_p14
    UNION ALL SELECT 'p15', COUNT(*) FROM user_hash_v1_p15
    UNION ALL SELECT 'p16', COUNT(*) FROM user_hash_v1_p16
    UNION ALL SELECT 'p17', COUNT(*) FROM user_hash_v1_p17
    UNION ALL SELECT 'p18', COUNT(*) FROM user_hash_v1_p18
    UNION ALL SELECT 'p19', COUNT(*) FROM user_hash_v1_p19
    UNION ALL SELECT 'p20', COUNT(*) FROM user_hash_v1_p20
    UNION ALL SELECT 'p21', COUNT(*) FROM user_hash_v1_p21
    UNION ALL SELECT 'p22', COUNT(*) FROM user_hash_v1_p22
    UNION ALL SELECT 'p23', COUNT(*) FROM user_hash_v1_p23
    UNION ALL SELECT 'p24', COUNT(*) FROM user_hash_v1_p24
    UNION ALL SELECT 'p25', COUNT(*) FROM user_hash_v1_p25
    UNION ALL SELECT 'p26', COUNT(*) FROM user_hash_v1_p26
)
SELECT partition, count, 
       ROUND((count * 100.0 / SUM(count) OVER()), 2) as percentage
FROM partition_counts 
ORDER BY partition;
"

echo ""
echo "4.2 Show data distribution across hash partitions for user_hash_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
WITH partition_counts AS (
    SELECT 'p0' as partition, COUNT(*) as count FROM user_hash_v2_p0
    UNION ALL SELECT 'p1', COUNT(*) FROM user_hash_v2_p1
    UNION ALL SELECT 'p2', COUNT(*) FROM user_hash_v2_p2
    UNION ALL SELECT 'p3', COUNT(*) FROM user_hash_v2_p3
    UNION ALL SELECT 'p4', COUNT(*) FROM user_hash_v2_p4
    UNION ALL SELECT 'p5', COUNT(*) FROM user_hash_v2_p5
    UNION ALL SELECT 'p6', COUNT(*) FROM user_hash_v2_p6
    UNION ALL SELECT 'p7', COUNT(*) FROM user_hash_v2_p7
    UNION ALL SELECT 'p8', COUNT(*) FROM user_hash_v2_p8
    UNION ALL SELECT 'p9', COUNT(*) FROM user_hash_v2_p9
    UNION ALL SELECT 'p10', COUNT(*) FROM user_hash_v2_p10
    UNION ALL SELECT 'p11', COUNT(*) FROM user_hash_v2_p11
    UNION ALL SELECT 'p12', COUNT(*) FROM user_hash_v2_p12
    UNION ALL SELECT 'p13', COUNT(*) FROM user_hash_v2_p13
    UNION ALL SELECT 'p14', COUNT(*) FROM user_hash_v2_p14
    UNION ALL SELECT 'p15', COUNT(*) FROM user_hash_v2_p15
    UNION ALL SELECT 'p16', COUNT(*) FROM user_hash_v2_p16
    UNION ALL SELECT 'p17', COUNT(*) FROM user_hash_v2_p17
    UNION ALL SELECT 'p18', COUNT(*) FROM user_hash_v2_p18
    UNION ALL SELECT 'p19', COUNT(*) FROM user_hash_v2_p19
    UNION ALL SELECT 'p20', COUNT(*) FROM user_hash_v2_p20
    UNION ALL SELECT 'p21', COUNT(*) FROM user_hash_v2_p21
    UNION ALL SELECT 'p22', COUNT(*) FROM user_hash_v2_p22
    UNION ALL SELECT 'p23', COUNT(*) FROM user_hash_v2_p23
    UNION ALL SELECT 'p24', COUNT(*) FROM user_hash_v2_p24
    UNION ALL SELECT 'p25', COUNT(*) FROM user_hash_v2_p25
    UNION ALL SELECT 'p26', COUNT(*) FROM user_hash_v2_p26
)
SELECT partition, count, 
       ROUND((count * 100.0 / SUM(count) OVER()), 2) as percentage
FROM partition_counts 
ORDER BY partition;
"

echo ""
echo "4.3 Demonstrate hash distribution statistics:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
WITH partition_counts AS (
    SELECT 'user_hash_v1' as table_name, COUNT(*) as min_count FROM user_hash_v1_p0
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p1
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p2
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p3
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p4
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p5
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p6
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p7
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p8
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p9
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p10
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p11
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p12
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p13
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p14
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p15
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p16
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p17
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p18
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p19
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p20
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p21
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p22
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p23
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p24
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p25
    UNION ALL SELECT 'user_hash_v1', COUNT(*) FROM user_hash_v1_p26
)
SELECT 
    table_name,
    MIN(min_count) as min_partition_size,
    MAX(min_count) as max_partition_size,
    ROUND(AVG(min_count), 2) as avg_partition_size,
    ROUND(STDDEV(min_count), 2) as stddev_partition_size
FROM partition_counts
GROUP BY table_name;
"

echo ""
echo "=========================================="
echo "HASH PARTITIONING EVIDENCE COMPLETE"
echo "=========================================="