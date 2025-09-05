# PostgreSQL Partitioning Playground

A comprehensive demonstration of PostgreSQL 17 partitioning strategies with performance benchmarks and evidence scripts.

## 🏗️ Architecture Overview

This playground demonstrates 4 different PostgreSQL partitioning strategies, each with 2 versions:
- **Version 1**: Explicit partition field (dedicated column for partitioning)
- **Version 2**: Derived partition key (computed from existing fields)

### Partitioning Strategies

| Strategy | Tables | Partitions | Description |
|----------|--------|------------|-------------|
| **Range** | `user_range_v1`, `user_range_v2` | 27 each | Data partitioned by value ranges |
| **List** | `user_list_v1`, `user_list_v2` | 27 each | Data partitioned by discrete value lists |
| **Hash** | `user_hash_v1`, `user_hash_v2` | 27 each | Data partitioned by hash function for even distribution |
| **Multilevel** | `user_multilevel_v1`, `user_multilevel_v2` | 27 each | Combined Range + Hash (3 range × 9 hash sub-partitions) |

## 📊 Performance Benchmark Results

### Query Performance Rankings (Based on PostgreSQL Timing)

| Rank | Strategy | Query Type | Execution Time | Planning Time | Query |
|------|----------|------------|---------------|---------------|-------|
| 🥇 **1st** | **Hash v1** | With partition key | **0.045ms** | 0.591ms | `SELECT * FROM user_hash_v1 WHERE hash_key = 150` |
| 🥈 **2nd** | **Multilevel v2** | Both partition keys | **0.028ms** | 0.748ms | `SELECT * FROM user_multilevel_v2 WHERE created_at >= '2025-06-15' AND created_at < '2025-06-16' AND user_id = 150` |
| 🥉 **3rd** | **Multilevel v1** | Both partition keys | **0.034ms** | 0.759ms | `SELECT * FROM user_multilevel_v1 WHERE date_partition = '2025-06-15' AND hash_partition = 150` |
| **4th** | **Hash v2** | With partition key | **0.039ms** | 0.473ms | `SELECT * FROM user_hash_v2 WHERE username = 'user_hash_v2_150'` |
| **5th** | **Range v1** | With partition key | **0.053ms** | 0.600ms | `SELECT * FROM user_range_v1 WHERE partition_key = 150` |
| **6th** | **Range v2** | With partition key | **0.060ms** | 0.755ms | `SELECT * FROM user_range_v2 WHERE user_id = 150` |

### Performance Analysis by Strategy

#### 🚀 **Hash Partitioning** - Best Overall Performance
- **Best for**: Uniform data distribution and equality queries
- **Partition pruning**: Excellent for exact matches
- **Distribution**: Most even across partitions (2.78% - 4.81% variance)

#### 🎯 **Multilevel Partitioning** - Best for Complex Queries
- **Best for**: Time-series data with additional hash distribution
- **Partition pruning**: Superior when both keys are used
- **Flexibility**: Excellent for both temporal and hash-based queries

#### 📈 **Range Partitioning** - Best for Range Queries
- **Best for**: Date ranges, numeric ranges, and sequential data
- **Partition pruning**: Excellent for range conditions
- **Performance**: Good single-partition access, excellent range scans

#### 📋 **List Partitioning** - Best for Categorical Data
- **Best for**: Geographic regions, categories, discrete values
- **Partition pruning**: Good for equality and IN clauses
- **Limitation**: Requires known value sets

## 🔍 Detailed Performance Results

### Range Partitioning Performance

| Query Type | Table | Execution Time | Query |
|------------|-------|----------------|-------|
| **With partition key** | `user_range_v1` | 0.053ms | `WHERE partition_key = 150` |
| **With partition key** | `user_range_v2` | 0.060ms | `WHERE user_id = 150` |
| **Range query** | `user_range_v1` | 0.097ms | `WHERE partition_key BETWEEN 100 AND 200` |
| **Without partition key** | `user_range_v1` | 0.359ms | `WHERE username LIKE 'user_15%'` |

### List Partitioning Performance

| Query Type | Table | Execution Time | Query |
|------------|-------|----------------|-------|
| **With partition key** | `user_list_v1` | 0.032ms | `WHERE region = 'US-EAST'` |
| **With partition key** | `user_list_v2` | 0.031ms | `WHERE SUBSTRING(email FROM '@(.*)$') = 'gmail.com'` |
| **Multiple values** | `user_list_v1` | 0.054ms | `WHERE region IN ('US-EAST', 'US-WEST', 'CA-EAST')` |
| **Without partition key** | `user_list_v1` | 0.382ms | `WHERE username LIKE 'user_list_1%'` |

### Hash Partitioning Performance

| Query Type | Table | Execution Time | Query |
|------------|-------|----------------|-------|
| **With partition key** | `user_hash_v1` | **0.045ms** | `WHERE hash_key = 150` |
| **With partition key** | `user_hash_v2` | **0.039ms** | `WHERE username = 'user_hash_v2_150'` |
| **Multiple values** | `user_hash_v1` | 0.075ms | `WHERE hash_key IN (100, 200, 300)` |
| **Without partition key** | `user_hash_v1` | 0.549ms | `WHERE email LIKE '%example.com'` |

### Multilevel Partitioning Performance

| Query Type | Table | Execution Time | Query |
|------------|-------|----------------|-------|
| **Both keys** | `user_multilevel_v1` | **0.034ms** | `WHERE date_partition = '2025-06-15' AND hash_partition = 150` |
| **Both keys** | `user_multilevel_v2` | **0.028ms** | `WHERE created_at >= '2025-06-15' AND created_at < '2025-06-16' AND user_id = 150` |
| **Range key only** | `user_multilevel_v1` | 0.200ms | `WHERE date_partition BETWEEN '2025-01-01' AND '2025-12-31'` |
| **Hash key only** | `user_multilevel_v1` | 0.100ms | `WHERE hash_partition = 555` |
| **Without partition keys** | `user_multilevel_v1` | 0.330ms | `WHERE username LIKE 'user_multi_15%'` |

## 📈 Data Distribution Analysis

### Hash Partitioning Distribution (Most Even)

**user_hash_v1 Statistics:**
- Min partition size: 30 records
- Max partition size: 52 records  
- Average: 40.00 records
- Standard deviation: 5.61

### Range Partitioning Distribution

**user_range_v1 Record Distribution:**
- Active partitions: 11 out of 27
- Records per partition: 81-100 records
- Distribution: Sequential based on partition_key values

### List Partitioning Distribution

**user_list_v1 Distribution:**
- Single active partition: `user_list_v1_p17` (OC-EAST region)
- All 1080 records in one partition due to random region assignment

### Multilevel Partitioning Distribution

**user_multilevel_v1 Year Distribution:**
- 2024: 365 records
- 2025: 365 records  
- 2026: 350 records

**Hash Sub-partitions (2025 year):**
- Range: 33-49 records per sub-partition
- Even distribution across 9 hash sub-partitions

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- PostgreSQL client (psql)

### Setup and Run

```bash
# Start PostgreSQL 17 with all partitioned tables
./run.sh

# Run all evidence scripts to see performance demonstrations
./run-all.sh

# Or run individual evidence scripts
./evidence_user_range.sh      # Range partitioning demos
./evidence_user_list.sh       # List partitioning demos  
./evidence_user_hash.sh       # Hash partitioning demos
./evidence_user_multilevel.sh # Multilevel partitioning demos
```

### Connection Details
```bash
Host: localhost
Port: 5432
Database: partitions_db
Username: postgres
Password: postgres

# Connect manually
psql -h localhost -p 5432 -U postgres -d partitions_db
```

## 📝 Table Schemas

### Range Partitioning Tables

```sql
-- Version 1: Explicit partition field
CREATE TABLE user_range_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    partition_key INTEGER NOT NULL  -- Explicit partition field
) PARTITION BY RANGE (partition_key);

-- Version 2: Derived partition key  
CREATE TABLE user_range_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,  -- Used as partition key
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (user_id);
```

### List Partitioning Tables

```sql
-- Version 1: Explicit partition field
CREATE TABLE user_list_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    region VARCHAR(10) NOT NULL  -- Explicit partition field
) PARTITION BY LIST (region);

-- Version 2: Derived partition key
CREATE TABLE user_list_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),  -- Email domain used as partition key
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY LIST (SUBSTRING(email FROM '@(.*)$'));
```

### Hash Partitioning Tables

```sql
-- Version 1: Explicit partition field
CREATE TABLE user_hash_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hash_key INTEGER NOT NULL  -- Explicit partition field
) PARTITION BY HASH (hash_key);

-- Version 2: Derived partition key
CREATE TABLE user_hash_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),  -- Username used as partition key
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY HASH (username);
```

### Multilevel Partitioning Tables

```sql
-- Version 1: Explicit partition fields
CREATE TABLE user_multilevel_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_partition DATE NOT NULL,      -- Range partition key
    hash_partition INTEGER NOT NULL    -- Hash partition key
) PARTITION BY RANGE (date_partition);
-- Then sub-partitioned by HASH (hash_partition)

-- Version 2: Derived partition keys
CREATE TABLE user_multilevel_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,           -- Hash partition key
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Range partition key
) PARTITION BY RANGE (created_at);
-- Then sub-partitioned by HASH (user_id)
```

## 🎯 Best Practices and Recommendations

### When to Use Each Strategy

#### ✅ **Hash Partitioning** - Choose When:
- You need uniform data distribution
- Queries primarily use equality conditions
- You don't need range queries
- You want the best single-row lookup performance

#### ✅ **Range Partitioning** - Choose When:
- You have time-series or sequential data
- You frequently query date ranges or numeric ranges
- You need partition pruning for range conditions
- You plan to drop old partitions (data retention)

#### ✅ **List Partitioning** - Choose When:
- You have categorical data with known values
- You query by specific categories (regions, types, etc.)
- You want to isolate data by business logic
- You have a limited set of partition values

#### ✅ **Multilevel Partitioning** - Choose When:
- You need both temporal and hash-based access patterns
- You have very large datasets requiring multiple partition levels
- You want optimal performance for complex queries
- You need the finest level of data organization

### Performance Tips

1. **Always include partition key in WHERE clauses** for optimal performance
2. **Use EXPLAIN (ANALYZE, BUFFERS)** to verify partition pruning
3. **Consider composite indexes** on frequently queried non-partition columns
4. **Monitor partition sizes** and rebalance if needed
5. **Plan partition maintenance** (especially for time-based partitions)

## 📚 Files in This Repository

```
├── docker-compose.yml           # PostgreSQL 17 setup
├── init.sql                    # Database schema and data initialization
├── evidence_user_range.sh      # Range partitioning demonstrations
├── evidence_user_list.sh       # List partitioning demonstrations  
├── evidence_user_hash.sh       # Hash partitioning demonstrations
├── evidence_user_multilevel.sh # Multilevel partitioning demonstrations
├── run-all.sh                  # Execute all evidence scripts
├── run.sh                      # Start PostgreSQL environment
└── README.md                   # This file
```

## 🔬 Evidence Script Features

Each evidence script demonstrates:

1. **Partition Structure**: Shows all created partitions and their definitions
2. **Data Distribution**: Displays record counts per partition
3. **Performance Testing**: Compares queries with and without partition keys
4. **Partition Pruning**: Shows PostgreSQL's query plan optimization
5. **Strategy-Specific Features**: Unique aspects of each partitioning method

## 📊 Key Insights from Testing

### 🚀 Hash partitioning provides the most consistent performance
- Fastest execution times for equality queries
- Most even data distribution
- Best for high-throughput OLTP workloads

### 🎯 Multilevel partitioning offers the most flexibility
- Excellent performance when both partition keys are used
- Good fallback performance with single keys
- Best for complex analytical workloads

### 📈 Range partitioning excels at range queries
- Superior for time-series data
- Excellent for data retention policies
- Good for sequential access patterns

### 📋 List partitioning is ideal for business logic separation
- Perfect for multi-tenant applications
- Good for geographic or categorical data segregation
- Allows business-driven data organization

---

**Created with PostgreSQL 17 | 1080+ records per table | 27+ partitions per strategy**