#!/bin/bash

echo "=========================================="
echo "EVIDENCE SCRIPT: USER_MULTILEVEL PARTITIONING"
echo "=========================================="

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="partitions_db"
DB_USER="postgres"
PGPASSWORD="postgres"

export PGPASSWORD

echo ""
echo "1. PROVING PARTITIONS EXIST FOR MULTILEVEL STRATEGY (Range + Hash)"
echo "-------------------------------------------------------------------"

echo ""
echo "1.1 List all main partitions for user_multilevel_v1 (explicit partition keys):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_multilevel_v1_202%'
  AND tablename NOT LIKE '%_h%'
ORDER BY tablename;
"

echo ""
echo "1.2 List all hash sub-partitions for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_multilevel_v1_%_h%'
ORDER BY tablename;
"

echo ""
echo "1.3 List all main partitions for user_multilevel_v2 (derived partition keys):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_multilevel_v2_202%'
  AND tablename NOT LIKE '%_h%'
ORDER BY tablename;
"

echo ""
echo "1.4 List all hash sub-partitions for user_multilevel_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT schemaname, tablename, 
       pg_get_expr(c.relpartbound, c.oid, true) as partition_expression
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
WHERE schemaname = 'public' 
  AND tablename LIKE 'user_multilevel_v2_%_h%'
ORDER BY tablename;
"

echo ""
echo "1.5 Show partition hierarchy from pg_inherits:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
WITH RECURSIVE partition_tree AS (
  -- Base case: find top-level partitioned tables
  SELECT 
    c.oid,
    c.relname,
    c.relname as root_table,
    0 as level,
    ARRAY[c.relname] as path
  FROM pg_class c
  WHERE c.relname IN ('user_multilevel_v1', 'user_multilevel_v2')
    AND c.relkind = 'p'
  
  UNION ALL
  
  -- Recursive case: find child partitions
  SELECT 
    child.oid,
    child.relname,
    pt.root_table,
    pt.level + 1,
    pt.path || child.relname
  FROM partition_tree pt
  JOIN pg_inherits i ON i.inhparent = pt.oid
  JOIN pg_class child ON child.oid = i.inhrelid
)
SELECT 
  root_table,
  level,
  REPEAT('  ', level) || relname as partition_name,
  CASE 
    WHEN level = 0 THEN 'ROOT TABLE'
    WHEN level = 1 THEN 'MAIN PARTITION'
    WHEN level = 2 THEN 'SUB-PARTITION'
    ELSE 'UNKNOWN'
  END as partition_type
FROM partition_tree
ORDER BY root_table, path;
"

echo ""
echo "1.6 Count records per main partition for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT '2024 partitions' as year_partition, COUNT(*) as record_count 
FROM user_multilevel_v1 WHERE date_partition >= '2024-01-01' AND date_partition < '2025-01-01'
UNION ALL
SELECT '2025 partitions', COUNT(*) 
FROM user_multilevel_v1 WHERE date_partition >= '2025-01-01' AND date_partition < '2026-01-01'
UNION ALL
SELECT '2026 partitions', COUNT(*) 
FROM user_multilevel_v1 WHERE date_partition >= '2026-01-01' AND date_partition < '2027-01-01'
ORDER BY year_partition;
"

echo ""
echo "1.7 Count records per sub-partition for user_multilevel_v1 (2024 year):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_multilevel_v1_2024_h0' as partition, COUNT(*) as record_count FROM user_multilevel_v1_2024_h0
UNION ALL SELECT 'user_multilevel_v1_2024_h1', COUNT(*) FROM user_multilevel_v1_2024_h1
UNION ALL SELECT 'user_multilevel_v1_2024_h2', COUNT(*) FROM user_multilevel_v1_2024_h2
UNION ALL SELECT 'user_multilevel_v1_2024_h3', COUNT(*) FROM user_multilevel_v1_2024_h3
UNION ALL SELECT 'user_multilevel_v1_2024_h4', COUNT(*) FROM user_multilevel_v1_2024_h4
UNION ALL SELECT 'user_multilevel_v1_2024_h5', COUNT(*) FROM user_multilevel_v1_2024_h5
UNION ALL SELECT 'user_multilevel_v1_2024_h6', COUNT(*) FROM user_multilevel_v1_2024_h6
UNION ALL SELECT 'user_multilevel_v1_2024_h7', COUNT(*) FROM user_multilevel_v1_2024_h7
UNION ALL SELECT 'user_multilevel_v1_2024_h8', COUNT(*) FROM user_multilevel_v1_2024_h8
ORDER BY partition;
"

echo ""
echo "=========================================="
echo "2. PERFORMANCE TESTING WITH TIMING"
echo "=========================================="

echo ""
echo "2.1 USER_MULTILEVEL_V1 TESTS (Explicit Partition Keys)"
echo "-------------------------------------------------------"

echo ""
echo "2.1.1 Query WITH both partition keys (date and hash) - SHOULD BE FASTEST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v1 
WHERE date_partition = '2025-06-15' AND hash_partition = 150;
EOF

echo ""
echo "2.1.2 Query WITH range partition key only - SHOULD BE FAST (prunes main partitions):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v1 
WHERE date_partition BETWEEN '2025-01-01' AND '2025-12-31';
EOF

echo ""
echo "2.1.3 Query WITH hash partition key only - SHOULD BE MODERATE (prunes sub-partitions):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_multilevel_v1 WHERE hash_partition = 555;
EOF

echo ""
echo "2.1.4 Query WITHOUT partition keys - SHOULD BE SLOWEST (full table scan):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v1 WHERE username LIKE 'user_multi_15%';
EOF

echo ""
echo "2.2 USER_MULTILEVEL_V2 TESTS (Derived Partition Keys)"
echo "------------------------------------------------------"

echo ""
echo "2.2.1 Query WITH both partition keys (created_at and user_id) - SHOULD BE FASTEST:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v2 
WHERE created_at >= '2025-06-15' AND created_at < '2025-06-16' AND user_id = 150;
EOF

echo ""
echo "2.2.2 Query WITH range partition key only - SHOULD BE FAST (prunes main partitions):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM user_multilevel_v2 
WHERE created_at BETWEEN '2025-01-01' AND '2025-12-31';
EOF

echo ""
echo "2.2.3 Query WITH hash partition key only - SHOULD BE MODERATE (prunes sub-partitions):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v2 WHERE user_id = 555;
EOF

echo ""
echo "2.2.4 Query WITHOUT partition keys - SHOULD BE SLOWEST (full table scan):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM user_multilevel_v2 WHERE email LIKE '%multiv2_user%';
EOF

echo ""
echo "=========================================="
echo "3. PARTITION PRUNING DEMONSTRATION"
echo "=========================================="

echo ""
echo "3.1 Show optimal partition pruning (both keys) for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_multilevel_v1 
WHERE date_partition = '2024-05-15' AND hash_partition = 123;
"

echo ""
echo "3.2 Show range-only partition pruning for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1 
WHERE date_partition >= '2025-01-01' AND date_partition < '2025-07-01';
"

echo ""
echo "3.3 Show hash-only partition pruning for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1 WHERE hash_partition = 777;
"

echo ""
echo "3.4 Show optimal partition pruning for user_multilevel_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM user_multilevel_v2 
WHERE created_at >= '2024-05-15' AND created_at < '2024-05-16' AND user_id = 123;
"

echo ""
echo "=========================================="
echo "4. MULTILEVEL-SPECIFIC DEMONSTRATIONS"
echo "=========================================="

echo ""
echo "4.1 Show data distribution across years for user_multilevel_v1:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    EXTRACT(YEAR FROM date_partition) as year,
    COUNT(*) as record_count,
    MIN(date_partition) as earliest_date,
    MAX(date_partition) as latest_date
FROM user_multilevel_v1 
GROUP BY EXTRACT(YEAR FROM date_partition)
ORDER BY year;
"

echo ""
echo "4.2 Show data distribution across hash sub-partitions for 2025:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 'user_multilevel_v1_2025_h0' as partition, COUNT(*) as record_count FROM user_multilevel_v1_2025_h0
UNION ALL SELECT 'user_multilevel_v1_2025_h1', COUNT(*) FROM user_multilevel_v1_2025_h1
UNION ALL SELECT 'user_multilevel_v1_2025_h2', COUNT(*) FROM user_multilevel_v1_2025_h2
UNION ALL SELECT 'user_multilevel_v1_2025_h3', COUNT(*) FROM user_multilevel_v1_2025_h3
UNION ALL SELECT 'user_multilevel_v1_2025_h4', COUNT(*) FROM user_multilevel_v1_2025_h4
UNION ALL SELECT 'user_multilevel_v1_2025_h5', COUNT(*) FROM user_multilevel_v1_2025_h5
UNION ALL SELECT 'user_multilevel_v1_2025_h6', COUNT(*) FROM user_multilevel_v1_2025_h6
UNION ALL SELECT 'user_multilevel_v1_2025_h7', COUNT(*) FROM user_multilevel_v1_2025_h7
UNION ALL SELECT 'user_multilevel_v1_2025_h8', COUNT(*) FROM user_multilevel_v1_2025_h8
ORDER BY partition;
"

echo ""
echo "4.3 Show data distribution across years for user_multilevel_v2:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    EXTRACT(YEAR FROM created_at) as year,
    COUNT(*) as record_count,
    MIN(created_at) as earliest_timestamp,
    MAX(created_at) as latest_timestamp
FROM user_multilevel_v2 
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;
"

echo ""
echo "4.4 Demonstrate partition elimination benefits:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
-- Show how many partitions are accessed with different WHERE clauses
EXPLAIN (FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1;
EXPLAIN (FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1 WHERE date_partition >= '2025-01-01';
EXPLAIN (FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1 WHERE hash_partition = 100;
EXPLAIN (FORMAT TEXT) 
SELECT COUNT(*) FROM user_multilevel_v1 WHERE date_partition >= '2025-01-01' AND hash_partition = 100;
"

echo ""
echo "4.5 Show total partition count:"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT 
    'user_multilevel_v1' as table_name,
    COUNT(*) as total_partitions
FROM pg_tables 
WHERE tablename LIKE 'user_multilevel_v1_%_h%'
UNION ALL
SELECT 
    'user_multilevel_v2' as table_name,
    COUNT(*) as total_partitions
FROM pg_tables 
WHERE tablename LIKE 'user_multilevel_v2_%_h%';
"

echo ""
echo "4.6 Performance comparison: single-level vs multilevel access patterns:"
echo "Single partition access (best case):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
SELECT COUNT(*) FROM user_multilevel_v1 
WHERE date_partition = '2025-03-15' AND hash_partition = 456;
EOF

echo ""
echo "Range partition access (good case):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
SELECT COUNT(*) FROM user_multilevel_v1 
WHERE date_partition BETWEEN '2025-01-01' AND '2025-01-31';
EOF

echo ""
echo "Hash-only access (moderate case):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
SELECT COUNT(*) FROM user_multilevel_v1 WHERE hash_partition = 789;
EOF

echo ""
echo "Full table access (worst case):"
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
\timing on
SELECT COUNT(*) FROM user_multilevel_v1 WHERE email LIKE '%example.com';
EOF

echo ""
echo "=========================================="
echo "MULTILEVEL PARTITIONING EVIDENCE COMPLETE"
echo "=========================================="