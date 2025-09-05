#!/bin/bash

echo "=========================================="
echo "EVIDENCE SCRIPT: USER_RANGE PARTITIONING"
echo "=========================================="

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="partitions_db"
DB_USER="postgres"
PGPASSWORD="postgres"

export PGPASSWORD

echo ""
echo "1. PROVING PARTITIONS EXIST FOR RANGE STRATEGY"
echo "----------------------------------------------"

echo ""
echo "1.1 List all partitions for user_range_v1 (explicit partition key):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_range_v1_p%'
ORDER BY tablename;
"

echo ""
echo "1.2 List all partitions for user_range_v2 (derived partition key):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_range_v2_p%'
ORDER BY tablename;
"

echo ""
echo "1.3 Show partition information from pg_partitions:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    schemaname,
    tablename as parent_table,
    partitionschemaname,
    partitiontablename,
    partitionrangestart,
    partitionrangeend
FROM pg_partitions 
WHERE tablename IN ('user_range_v1', 'user_range_v2')
ORDER BY tablename, partitionrangestart;
"

echo ""
echo "1.4 Count records per partition for user_range_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_range_v1_p1' as partition, COUNT(*) as record_count FROM user_range_v1_p1
UNION ALL SELECT 'user_range_v1_p2', COUNT(*) FROM user_range_v1_p2
UNION ALL SELECT 'user_range_v1_p3', COUNT(*) FROM user_range_v1_p3
UNION ALL SELECT 'user_range_v1_p4', COUNT(*) FROM user_range_v1_p4
UNION ALL SELECT 'user_range_v1_p5', COUNT(*) FROM user_range_v1_p5
UNION ALL SELECT 'user_range_v1_p6', COUNT(*) FROM user_range_v1_p6
UNION ALL SELECT 'user_range_v1_p7', COUNT(*) FROM user_range_v1_p7
UNION ALL SELECT 'user_range_v1_p8', COUNT(*) FROM user_range_v1_p8
UNION ALL SELECT 'user_range_v1_p9', COUNT(*) FROM user_range_v1_p9
UNION ALL SELECT 'user_range_v1_p10', COUNT(*) FROM user_range_v1_p10
UNION ALL SELECT 'user_range_v1_p11', COUNT(*) FROM user_range_v1_p11
UNION ALL SELECT 'user_range_v1_p12', COUNT(*) FROM user_range_v1_p12
UNION ALL SELECT 'user_range_v1_p13', COUNT(*) FROM user_range_v1_p13
UNION ALL SELECT 'user_range_v1_p14', COUNT(*) FROM user_range_v1_p14
UNION ALL SELECT 'user_range_v1_p15', COUNT(*) FROM user_range_v1_p15
UNION ALL SELECT 'user_range_v1_p16', COUNT(*) FROM user_range_v1_p16
UNION ALL SELECT 'user_range_v1_p17', COUNT(*) FROM user_range_v1_p17
UNION ALL SELECT 'user_range_v1_p18', COUNT(*) FROM user_range_v1_p18
UNION ALL SELECT 'user_range_v1_p19', COUNT(*) FROM user_range_v1_p19
UNION ALL SELECT 'user_range_v1_p20', COUNT(*) FROM user_range_v1_p20
UNION ALL SELECT 'user_range_v1_p21', COUNT(*) FROM user_range_v1_p21
UNION ALL SELECT 'user_range_v1_p22', COUNT(*) FROM user_range_v1_p22
UNION ALL SELECT 'user_range_v1_p23', COUNT(*) FROM user_range_v1_p23
UNION ALL SELECT 'user_range_v1_p24', COUNT(*) FROM user_range_v1_p24
UNION ALL SELECT 'user_range_v1_p25', COUNT(*) FROM user_range_v1_p25
UNION ALL SELECT 'user_range_v1_p26', COUNT(*) FROM user_range_v1_p26
UNION ALL SELECT 'user_range_v1_p27', COUNT(*) FROM user_range_v1_p27
ORDER BY partition;
"

echo ""
echo "1.5 Count records per partition for user_range_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_range_v2_p1' as partition, COUNT(*) as record_count FROM user_range_v2_p1
UNION ALL SELECT 'user_range_v2_p2', COUNT(*) FROM user_range_v2_p2
UNION ALL SELECT 'user_range_v2_p3', COUNT(*) FROM user_range_v2_p3
UNION ALL SELECT 'user_range_v2_p4', COUNT(*) FROM user_range_v2_p4
UNION ALL SELECT 'user_range_v2_p5', COUNT(*) FROM user_range_v2_p5
UNION ALL SELECT 'user_range_v2_p6', COUNT(*) FROM user_range_v2_p6
UNION ALL SELECT 'user_range_v2_p7', COUNT(*) FROM user_range_v2_p7
UNION ALL SELECT 'user_range_v2_p8', COUNT(*) FROM user_range_v2_p8
UNION ALL SELECT 'user_range_v2_p9', COUNT(*) FROM user_range_v2_p9
UNION ALL SELECT 'user_range_v2_p10', COUNT(*) FROM user_range_v2_p10
UNION ALL SELECT 'user_range_v2_p11', COUNT(*) FROM user_range_v2_p11
UNION ALL SELECT 'user_range_v2_p12', COUNT(*) FROM user_range_v2_p12
UNION ALL SELECT 'user_range_v2_p13', COUNT(*) FROM user_range_v2_p13
UNION ALL SELECT 'user_range_v2_p14', COUNT(*) FROM user_range_v2_p14
UNION ALL SELECT 'user_range_v2_p15', COUNT(*) FROM user_range_v2_p15
UNION ALL SELECT 'user_range_v2_p16', COUNT(*) FROM user_range_v2_p16
UNION ALL SELECT 'user_range_v2_p17', COUNT(*) FROM user_range_v2_p17
UNION ALL SELECT 'user_range_v2_p18', COUNT(*) FROM user_range_v2_p18
UNION ALL SELECT 'user_range_v2_p19', COUNT(*) FROM user_range_v2_p19
UNION ALL SELECT 'user_range_v2_p20', COUNT(*) FROM user_range_v2_p20
UNION ALL SELECT 'user_range_v2_p21', COUNT(*) FROM user_range_v2_p21
UNION ALL SELECT 'user_range_v2_p22', COUNT(*) FROM user_range_v2_p22
UNION ALL SELECT 'user_range_v2_p23', COUNT(*) FROM user_range_v2_p23
UNION ALL SELECT 'user_range_v2_p24', COUNT(*) FROM user_range_v2_p24
UNION ALL SELECT 'user_range_v2_p25', COUNT(*) FROM user_range_v2_p25
UNION ALL SELECT 'user_range_v2_p26', COUNT(*) FROM user_range_v2_p26
UNION ALL SELECT 'user_range_v2_p27', COUNT(*) FROM user_range_v2_p27
ORDER BY partition;
"

echo ""
echo "=========================================="
echo "2. PERFORMANCE TESTING WITH TIMING"
echo "=========================================="

echo ""
echo "2.1 USER_RANGE_V1 TESTS (Explicit Partition Key)"
echo "-------------------------------------------------"

echo ""
echo "2.1.1 Query WITH partition key (partition_key = 150) - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_range_v1 WHERE partition_key = 150;
EOF

echo ""
echo "2.1.2 Query WITHOUT partition key (username LIKE pattern) - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_range_v1 WHERE username LIKE 'user_15%';
EOF

echo ""
echo "2.1.3 Range query WITH partition key - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_range_v1 WHERE partition_key BETWEEN 100 AND 200;
EOF

echo ""
echo "2.1.4 Aggregate query WITHOUT partition key - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_range_v1 WHERE email LIKE '%example.com';
EOF

echo ""
echo "2.2 USER_RANGE_V2 TESTS (Derived Partition Key)"
echo "------------------------------------------------"

echo ""
echo "2.2.1 Query WITH partition key (user_id = 150) - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_range_v2 WHERE user_id = 150;
EOF

echo ""
echo "2.2.2 Query WITHOUT partition key (username LIKE pattern) - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_range_v2 WHERE username LIKE 'user_range_v2_15%';
EOF

echo ""
echo "2.2.3 Range query WITH partition key - SHOULD BE FAST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_range_v2 WHERE user_id BETWEEN 100 AND 200;
EOF

echo ""
echo "2.2.4 Aggregate query WITHOUT partition key - SHOULD BE SLOWER:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_range_v2 WHERE email LIKE '%example.com';
EOF

echo ""
echo "=========================================="
echo "3. PARTITION PRUNING DEMONSTRATION"
echo "=========================================="

echo ""
echo "3.1 Show partition pruning for user_range_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_range_v1 WHERE partition_key = 550;
"

echo ""
echo "3.2 Show partition pruning for user_range_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_range_v2 WHERE user_id = 550;
"

echo ""
echo "3.3 Show full table scan (no partition pruning):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT COUNT(*) FROM user_range_v1 WHERE username LIKE '%user%';
"

echo ""
echo "=========================================="
echo "RANGE PARTITIONING EVIDENCE COMPLETE"
echo "=========================================="