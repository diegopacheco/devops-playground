-- PostgreSQL Partitioning Playground Init Script
-- Creates 4 different partitioning strategies with 2 versions each

-- Enable timing for all statements
\timing on

-- ========================================
-- 1. RANGE PARTITIONING TABLES
-- ========================================

-- Version 1: user_range_v1 (explicit partition field)
CREATE TABLE user_range_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    partition_key INTEGER NOT NULL
) PARTITION BY RANGE (partition_key);

-- Create 27 range partitions for user_range_v1
CREATE TABLE user_range_v1_p1 PARTITION OF user_range_v1 FOR VALUES FROM (1) TO (100);
CREATE TABLE user_range_v1_p2 PARTITION OF user_range_v1 FOR VALUES FROM (100) TO (200);
CREATE TABLE user_range_v1_p3 PARTITION OF user_range_v1 FOR VALUES FROM (200) TO (300);
CREATE TABLE user_range_v1_p4 PARTITION OF user_range_v1 FOR VALUES FROM (300) TO (400);
CREATE TABLE user_range_v1_p5 PARTITION OF user_range_v1 FOR VALUES FROM (400) TO (500);
CREATE TABLE user_range_v1_p6 PARTITION OF user_range_v1 FOR VALUES FROM (500) TO (600);
CREATE TABLE user_range_v1_p7 PARTITION OF user_range_v1 FOR VALUES FROM (600) TO (700);
CREATE TABLE user_range_v1_p8 PARTITION OF user_range_v1 FOR VALUES FROM (700) TO (800);
CREATE TABLE user_range_v1_p9 PARTITION OF user_range_v1 FOR VALUES FROM (800) TO (900);
CREATE TABLE user_range_v1_p10 PARTITION OF user_range_v1 FOR VALUES FROM (900) TO (1000);
CREATE TABLE user_range_v1_p11 PARTITION OF user_range_v1 FOR VALUES FROM (1000) TO (1100);
CREATE TABLE user_range_v1_p12 PARTITION OF user_range_v1 FOR VALUES FROM (1100) TO (1200);
CREATE TABLE user_range_v1_p13 PARTITION OF user_range_v1 FOR VALUES FROM (1200) TO (1300);
CREATE TABLE user_range_v1_p14 PARTITION OF user_range_v1 FOR VALUES FROM (1300) TO (1400);
CREATE TABLE user_range_v1_p15 PARTITION OF user_range_v1 FOR VALUES FROM (1400) TO (1500);
CREATE TABLE user_range_v1_p16 PARTITION OF user_range_v1 FOR VALUES FROM (1500) TO (1600);
CREATE TABLE user_range_v1_p17 PARTITION OF user_range_v1 FOR VALUES FROM (1600) TO (1700);
CREATE TABLE user_range_v1_p18 PARTITION OF user_range_v1 FOR VALUES FROM (1700) TO (1800);
CREATE TABLE user_range_v1_p19 PARTITION OF user_range_v1 FOR VALUES FROM (1800) TO (1900);
CREATE TABLE user_range_v1_p20 PARTITION OF user_range_v1 FOR VALUES FROM (1900) TO (2000);
CREATE TABLE user_range_v1_p21 PARTITION OF user_range_v1 FOR VALUES FROM (2000) TO (2100);
CREATE TABLE user_range_v1_p22 PARTITION OF user_range_v1 FOR VALUES FROM (2100) TO (2200);
CREATE TABLE user_range_v1_p23 PARTITION OF user_range_v1 FOR VALUES FROM (2200) TO (2300);
CREATE TABLE user_range_v1_p24 PARTITION OF user_range_v1 FOR VALUES FROM (2300) TO (2400);
CREATE TABLE user_range_v1_p25 PARTITION OF user_range_v1 FOR VALUES FROM (2400) TO (2500);
CREATE TABLE user_range_v1_p26 PARTITION OF user_range_v1 FOR VALUES FROM (2500) TO (2600);
CREATE TABLE user_range_v1_p27 PARTITION OF user_range_v1 FOR VALUES FROM (2600) TO (2700);

-- Version 2: user_range_v2 (derived partition key from user_id)
CREATE TABLE user_range_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (user_id);

-- Create 27 range partitions for user_range_v2
CREATE TABLE user_range_v2_p1 PARTITION OF user_range_v2 FOR VALUES FROM (1) TO (100);
CREATE TABLE user_range_v2_p2 PARTITION OF user_range_v2 FOR VALUES FROM (100) TO (200);
CREATE TABLE user_range_v2_p3 PARTITION OF user_range_v2 FOR VALUES FROM (200) TO (300);
CREATE TABLE user_range_v2_p4 PARTITION OF user_range_v2 FOR VALUES FROM (300) TO (400);
CREATE TABLE user_range_v2_p5 PARTITION OF user_range_v2 FOR VALUES FROM (400) TO (500);
CREATE TABLE user_range_v2_p6 PARTITION OF user_range_v2 FOR VALUES FROM (500) TO (600);
CREATE TABLE user_range_v2_p7 PARTITION OF user_range_v2 FOR VALUES FROM (600) TO (700);
CREATE TABLE user_range_v2_p8 PARTITION OF user_range_v2 FOR VALUES FROM (700) TO (800);
CREATE TABLE user_range_v2_p9 PARTITION OF user_range_v2 FOR VALUES FROM (800) TO (900);
CREATE TABLE user_range_v2_p10 PARTITION OF user_range_v2 FOR VALUES FROM (900) TO (1000);
CREATE TABLE user_range_v2_p11 PARTITION OF user_range_v2 FOR VALUES FROM (1000) TO (1100);
CREATE TABLE user_range_v2_p12 PARTITION OF user_range_v2 FOR VALUES FROM (1100) TO (1200);
CREATE TABLE user_range_v2_p13 PARTITION OF user_range_v2 FOR VALUES FROM (1200) TO (1300);
CREATE TABLE user_range_v2_p14 PARTITION OF user_range_v2 FOR VALUES FROM (1300) TO (1400);
CREATE TABLE user_range_v2_p15 PARTITION OF user_range_v2 FOR VALUES FROM (1400) TO (1500);
CREATE TABLE user_range_v2_p16 PARTITION OF user_range_v2 FOR VALUES FROM (1500) TO (1600);
CREATE TABLE user_range_v2_p17 PARTITION OF user_range_v2 FOR VALUES FROM (1600) TO (1700);
CREATE TABLE user_range_v2_p18 PARTITION OF user_range_v2 FOR VALUES FROM (1700) TO (1800);
CREATE TABLE user_range_v2_p19 PARTITION OF user_range_v2 FOR VALUES FROM (1800) TO (1900);
CREATE TABLE user_range_v2_p20 PARTITION OF user_range_v2 FOR VALUES FROM (1900) TO (2000);
CREATE TABLE user_range_v2_p21 PARTITION OF user_range_v2 FOR VALUES FROM (2000) TO (2100);
CREATE TABLE user_range_v2_p22 PARTITION OF user_range_v2 FOR VALUES FROM (2100) TO (2200);
CREATE TABLE user_range_v2_p23 PARTITION OF user_range_v2 FOR VALUES FROM (2200) TO (2300);
CREATE TABLE user_range_v2_p24 PARTITION OF user_range_v2 FOR VALUES FROM (2300) TO (2400);
CREATE TABLE user_range_v2_p25 PARTITION OF user_range_v2 FOR VALUES FROM (2400) TO (2500);
CREATE TABLE user_range_v2_p26 PARTITION OF user_range_v2 FOR VALUES FROM (2500) TO (2600);
CREATE TABLE user_range_v2_p27 PARTITION OF user_range_v2 FOR VALUES FROM (2600) TO (2700);

-- ========================================
-- 2. LIST PARTITIONING TABLES
-- ========================================

-- Version 1: user_list_v1 (explicit partition field)
CREATE TABLE user_list_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    region VARCHAR(10) NOT NULL
) PARTITION BY LIST (region);

-- Create 27 list partitions for user_list_v1
CREATE TABLE user_list_v1_p1 PARTITION OF user_list_v1 FOR VALUES IN ('US-EAST');
CREATE TABLE user_list_v1_p2 PARTITION OF user_list_v1 FOR VALUES IN ('US-WEST');
CREATE TABLE user_list_v1_p3 PARTITION OF user_list_v1 FOR VALUES IN ('US-CENT');
CREATE TABLE user_list_v1_p4 PARTITION OF user_list_v1 FOR VALUES IN ('CA-EAST');
CREATE TABLE user_list_v1_p5 PARTITION OF user_list_v1 FOR VALUES IN ('CA-WEST');
CREATE TABLE user_list_v1_p6 PARTITION OF user_list_v1 FOR VALUES IN ('EU-NORTH');
CREATE TABLE user_list_v1_p7 PARTITION OF user_list_v1 FOR VALUES IN ('EU-SOUTH');
CREATE TABLE user_list_v1_p8 PARTITION OF user_list_v1 FOR VALUES IN ('EU-EAST');
CREATE TABLE user_list_v1_p9 PARTITION OF user_list_v1 FOR VALUES IN ('EU-WEST');
CREATE TABLE user_list_v1_p10 PARTITION OF user_list_v1 FOR VALUES IN ('AS-EAST');
CREATE TABLE user_list_v1_p11 PARTITION OF user_list_v1 FOR VALUES IN ('AS-WEST');
CREATE TABLE user_list_v1_p12 PARTITION OF user_list_v1 FOR VALUES IN ('AS-SOUTH');
CREATE TABLE user_list_v1_p13 PARTITION OF user_list_v1 FOR VALUES IN ('SA-NORTH');
CREATE TABLE user_list_v1_p14 PARTITION OF user_list_v1 FOR VALUES IN ('SA-SOUTH');
CREATE TABLE user_list_v1_p15 PARTITION OF user_list_v1 FOR VALUES IN ('AF-NORTH');
CREATE TABLE user_list_v1_p16 PARTITION OF user_list_v1 FOR VALUES IN ('AF-SOUTH');
CREATE TABLE user_list_v1_p17 PARTITION OF user_list_v1 FOR VALUES IN ('OC-EAST');
CREATE TABLE user_list_v1_p18 PARTITION OF user_list_v1 FOR VALUES IN ('OC-WEST');
CREATE TABLE user_list_v1_p19 PARTITION OF user_list_v1 FOR VALUES IN ('ME-NORTH');
CREATE TABLE user_list_v1_p20 PARTITION OF user_list_v1 FOR VALUES IN ('ME-SOUTH');
CREATE TABLE user_list_v1_p21 PARTITION OF user_list_v1 FOR VALUES IN ('IN-NORTH');
CREATE TABLE user_list_v1_p22 PARTITION OF user_list_v1 FOR VALUES IN ('IN-SOUTH');
CREATE TABLE user_list_v1_p23 PARTITION OF user_list_v1 FOR VALUES IN ('BR-NORTH');
CREATE TABLE user_list_v1_p24 PARTITION OF user_list_v1 FOR VALUES IN ('BR-SOUTH');
CREATE TABLE user_list_v1_p25 PARTITION OF user_list_v1 FOR VALUES IN ('MX-NORTH');
CREATE TABLE user_list_v1_p26 PARTITION OF user_list_v1 FOR VALUES IN ('MX-SOUTH');
CREATE TABLE user_list_v1_p27 PARTITION OF user_list_v1 FOR VALUES IN ('OTHER');

-- Version 2: user_list_v2 (derived partition key from email domain)
CREATE TABLE user_list_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY LIST (SUBSTRING(email FROM '@(.*)$'));

-- Create 27 list partitions for user_list_v2 based on email domains
CREATE TABLE user_list_v2_p1 PARTITION OF user_list_v2 FOR VALUES IN ('gmail.com');
CREATE TABLE user_list_v2_p2 PARTITION OF user_list_v2 FOR VALUES IN ('yahoo.com');
CREATE TABLE user_list_v2_p3 PARTITION OF user_list_v2 FOR VALUES IN ('outlook.com');
CREATE TABLE user_list_v2_p4 PARTITION OF user_list_v2 FOR VALUES IN ('hotmail.com');
CREATE TABLE user_list_v2_p5 PARTITION OF user_list_v2 FOR VALUES IN ('company1.com');
CREATE TABLE user_list_v2_p6 PARTITION OF user_list_v2 FOR VALUES IN ('company2.com');
CREATE TABLE user_list_v2_p7 PARTITION OF user_list_v2 FOR VALUES IN ('company3.com');
CREATE TABLE user_list_v2_p8 PARTITION OF user_list_v2 FOR VALUES IN ('company4.com');
CREATE TABLE user_list_v2_p9 PARTITION OF user_list_v2 FOR VALUES IN ('company5.com');
CREATE TABLE user_list_v2_p10 PARTITION OF user_list_v2 FOR VALUES IN ('company6.com');
CREATE TABLE user_list_v2_p11 PARTITION OF user_list_v2 FOR VALUES IN ('company7.com');
CREATE TABLE user_list_v2_p12 PARTITION OF user_list_v2 FOR VALUES IN ('company8.com');
CREATE TABLE user_list_v2_p13 PARTITION OF user_list_v2 FOR VALUES IN ('company9.com');
CREATE TABLE user_list_v2_p14 PARTITION OF user_list_v2 FOR VALUES IN ('company10.com');
CREATE TABLE user_list_v2_p15 PARTITION OF user_list_v2 FOR VALUES IN ('university1.edu');
CREATE TABLE user_list_v2_p16 PARTITION OF user_list_v2 FOR VALUES IN ('university2.edu');
CREATE TABLE user_list_v2_p17 PARTITION OF user_list_v2 FOR VALUES IN ('university3.edu');
CREATE TABLE user_list_v2_p18 PARTITION OF user_list_v2 FOR VALUES IN ('government1.gov');
CREATE TABLE user_list_v2_p19 PARTITION OF user_list_v2 FOR VALUES IN ('government2.gov');
CREATE TABLE user_list_v2_p20 PARTITION OF user_list_v2 FOR VALUES IN ('organization1.org');
CREATE TABLE user_list_v2_p21 PARTITION OF user_list_v2 FOR VALUES IN ('organization2.org');
CREATE TABLE user_list_v2_p22 PARTITION OF user_list_v2 FOR VALUES IN ('startup1.io');
CREATE TABLE user_list_v2_p23 PARTITION OF user_list_v2 FOR VALUES IN ('startup2.io');
CREATE TABLE user_list_v2_p24 PARTITION OF user_list_v2 FOR VALUES IN ('tech1.tech');
CREATE TABLE user_list_v2_p25 PARTITION OF user_list_v2 FOR VALUES IN ('tech2.tech');
CREATE TABLE user_list_v2_p26 PARTITION OF user_list_v2 FOR VALUES IN ('global.net');
CREATE TABLE user_list_v2_p27 PARTITION OF user_list_v2 FOR VALUES IN ('example.com');

-- ========================================
-- 3. HASH PARTITIONING TABLES
-- ========================================

-- Version 1: user_hash_v1 (explicit partition field)
CREATE TABLE user_hash_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hash_key INTEGER NOT NULL
) PARTITION BY HASH (hash_key);

-- Create 27 hash partitions for user_hash_v1
CREATE TABLE user_hash_v1_p0 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 0);
CREATE TABLE user_hash_v1_p1 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 1);
CREATE TABLE user_hash_v1_p2 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 2);
CREATE TABLE user_hash_v1_p3 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 3);
CREATE TABLE user_hash_v1_p4 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 4);
CREATE TABLE user_hash_v1_p5 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 5);
CREATE TABLE user_hash_v1_p6 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 6);
CREATE TABLE user_hash_v1_p7 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 7);
CREATE TABLE user_hash_v1_p8 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 8);
CREATE TABLE user_hash_v1_p9 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 9);
CREATE TABLE user_hash_v1_p10 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 10);
CREATE TABLE user_hash_v1_p11 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 11);
CREATE TABLE user_hash_v1_p12 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 12);
CREATE TABLE user_hash_v1_p13 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 13);
CREATE TABLE user_hash_v1_p14 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 14);
CREATE TABLE user_hash_v1_p15 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 15);
CREATE TABLE user_hash_v1_p16 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 16);
CREATE TABLE user_hash_v1_p17 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 17);
CREATE TABLE user_hash_v1_p18 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 18);
CREATE TABLE user_hash_v1_p19 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 19);
CREATE TABLE user_hash_v1_p20 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 20);
CREATE TABLE user_hash_v1_p21 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 21);
CREATE TABLE user_hash_v1_p22 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 22);
CREATE TABLE user_hash_v1_p23 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 23);
CREATE TABLE user_hash_v1_p24 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 24);
CREATE TABLE user_hash_v1_p25 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 25);
CREATE TABLE user_hash_v1_p26 PARTITION OF user_hash_v1 FOR VALUES WITH (modulus 27, remainder 26);

-- Version 2: user_hash_v2 (derived partition key from username)
CREATE TABLE user_hash_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY HASH (username);

-- Create 27 hash partitions for user_hash_v2
CREATE TABLE user_hash_v2_p0 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 0);
CREATE TABLE user_hash_v2_p1 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 1);
CREATE TABLE user_hash_v2_p2 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 2);
CREATE TABLE user_hash_v2_p3 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 3);
CREATE TABLE user_hash_v2_p4 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 4);
CREATE TABLE user_hash_v2_p5 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 5);
CREATE TABLE user_hash_v2_p6 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 6);
CREATE TABLE user_hash_v2_p7 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 7);
CREATE TABLE user_hash_v2_p8 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 8);
CREATE TABLE user_hash_v2_p9 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 9);
CREATE TABLE user_hash_v2_p10 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 10);
CREATE TABLE user_hash_v2_p11 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 11);
CREATE TABLE user_hash_v2_p12 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 12);
CREATE TABLE user_hash_v2_p13 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 13);
CREATE TABLE user_hash_v2_p14 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 14);
CREATE TABLE user_hash_v2_p15 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 15);
CREATE TABLE user_hash_v2_p16 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 16);
CREATE TABLE user_hash_v2_p17 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 17);
CREATE TABLE user_hash_v2_p18 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 18);
CREATE TABLE user_hash_v2_p19 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 19);
CREATE TABLE user_hash_v2_p20 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 20);
CREATE TABLE user_hash_v2_p21 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 21);
CREATE TABLE user_hash_v2_p22 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 22);
CREATE TABLE user_hash_v2_p23 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 23);
CREATE TABLE user_hash_v2_p24 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 24);
CREATE TABLE user_hash_v2_p25 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 25);
CREATE TABLE user_hash_v2_p26 PARTITION OF user_hash_v2 FOR VALUES WITH (modulus 27, remainder 26);

-- ========================================
-- 4. MULTILEVEL PARTITIONING TABLES (Range + Hash)
-- ========================================

-- Version 1: user_multilevel_v1 (explicit partition fields)
CREATE TABLE user_multilevel_v1 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_partition DATE NOT NULL,
    hash_partition INTEGER NOT NULL
) PARTITION BY RANGE (date_partition);

-- Create 3 main date partitions, then sub-partition each by hash (9 sub-partitions each = 27 total)
CREATE TABLE user_multilevel_v1_2024 PARTITION OF user_multilevel_v1 
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01')
    PARTITION BY HASH (hash_partition);

CREATE TABLE user_multilevel_v1_2025 PARTITION OF user_multilevel_v1 
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01')
    PARTITION BY HASH (hash_partition);

CREATE TABLE user_multilevel_v1_2026 PARTITION OF user_multilevel_v1 
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01')
    PARTITION BY HASH (hash_partition);

-- Create hash sub-partitions for 2024
CREATE TABLE user_multilevel_v1_2024_h0 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v1_2024_h1 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v1_2024_h2 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v1_2024_h3 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v1_2024_h4 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v1_2024_h5 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v1_2024_h6 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v1_2024_h7 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v1_2024_h8 PARTITION OF user_multilevel_v1_2024 FOR VALUES WITH (modulus 9, remainder 8);

-- Create hash sub-partitions for 2025
CREATE TABLE user_multilevel_v1_2025_h0 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v1_2025_h1 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v1_2025_h2 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v1_2025_h3 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v1_2025_h4 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v1_2025_h5 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v1_2025_h6 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v1_2025_h7 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v1_2025_h8 PARTITION OF user_multilevel_v1_2025 FOR VALUES WITH (modulus 9, remainder 8);

-- Create hash sub-partitions for 2026
CREATE TABLE user_multilevel_v1_2026_h0 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v1_2026_h1 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v1_2026_h2 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v1_2026_h3 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v1_2026_h4 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v1_2026_h5 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v1_2026_h6 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v1_2026_h7 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v1_2026_h8 PARTITION OF user_multilevel_v1_2026 FOR VALUES WITH (modulus 9, remainder 8);

-- Version 2: user_multilevel_v2 (derived partition keys)
CREATE TABLE user_multilevel_v2 (
    id SERIAL,
    user_id INTEGER NOT NULL,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (created_at);

-- Create 3 main date partitions, then sub-partition each by hash on user_id (9 sub-partitions each = 27 total)
CREATE TABLE user_multilevel_v2_2024 PARTITION OF user_multilevel_v2 
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01')
    PARTITION BY HASH (user_id);

CREATE TABLE user_multilevel_v2_2025 PARTITION OF user_multilevel_v2 
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01')
    PARTITION BY HASH (user_id);

CREATE TABLE user_multilevel_v2_2026 PARTITION OF user_multilevel_v2 
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01')
    PARTITION BY HASH (user_id);

-- Create hash sub-partitions for 2024
CREATE TABLE user_multilevel_v2_2024_h0 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v2_2024_h1 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v2_2024_h2 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v2_2024_h3 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v2_2024_h4 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v2_2024_h5 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v2_2024_h6 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v2_2024_h7 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v2_2024_h8 PARTITION OF user_multilevel_v2_2024 FOR VALUES WITH (modulus 9, remainder 8);

-- Create hash sub-partitions for 2025
CREATE TABLE user_multilevel_v2_2025_h0 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v2_2025_h1 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v2_2025_h2 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v2_2025_h3 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v2_2025_h4 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v2_2025_h5 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v2_2025_h6 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v2_2025_h7 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v2_2025_h8 PARTITION OF user_multilevel_v2_2025 FOR VALUES WITH (modulus 9, remainder 8);

-- Create hash sub-partitions for 2026
CREATE TABLE user_multilevel_v2_2026_h0 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 0);
CREATE TABLE user_multilevel_v2_2026_h1 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 1);
CREATE TABLE user_multilevel_v2_2026_h2 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 2);
CREATE TABLE user_multilevel_v2_2026_h3 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 3);
CREATE TABLE user_multilevel_v2_2026_h4 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 4);
CREATE TABLE user_multilevel_v2_2026_h5 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 5);
CREATE TABLE user_multilevel_v2_2026_h6 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 6);
CREATE TABLE user_multilevel_v2_2026_h7 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 7);
CREATE TABLE user_multilevel_v2_2026_h8 PARTITION OF user_multilevel_v2_2026 FOR VALUES WITH (modulus 9, remainder 8);

-- ========================================
-- DATA INSERTION
-- ========================================

-- Insert data into user_range_v1 (1000+ records across all partitions)
INSERT INTO user_range_v1 (user_id, username, email, partition_key)
SELECT 
    i,
    'user_' || i,
    'user' || i || '@example.com',
    ((i - 1) % 2699) + 1  -- Distribute across all 27 partitions (1-2699)
FROM generate_series(1, 1080) i;

-- Insert data into user_range_v2 (1000+ records across all partitions)
INSERT INTO user_range_v2 (user_id, username, email)
SELECT 
    ((i - 1) % 2699) + 1,  -- Distribute across all 27 partitions (1-2699)
    'user_range_v2_' || i,
    'userv2_' || i || '@example.com'
FROM generate_series(1, 1080) i;

-- Insert data into user_list_v1 (1000+ records across all partitions)
WITH regions AS (
    SELECT unnest(ARRAY[
        'US-EAST', 'US-WEST', 'US-CENT', 'CA-EAST', 'CA-WEST', 'EU-NORTH', 'EU-SOUTH', 'EU-EAST', 'EU-WEST',
        'AS-EAST', 'AS-WEST', 'AS-SOUTH', 'SA-NORTH', 'SA-SOUTH', 'AF-NORTH', 'AF-SOUTH', 'OC-EAST', 'OC-WEST',
        'ME-NORTH', 'ME-SOUTH', 'IN-NORTH', 'IN-SOUTH', 'BR-NORTH', 'BR-SOUTH', 'MX-NORTH', 'MX-SOUTH', 'OTHER'
    ]) AS region_name
)
INSERT INTO user_list_v1 (user_id, username, email, region)
SELECT 
    i,
    'user_list_' || i,
    'list_user' || i || '@example.com',
    (SELECT region_name FROM regions ORDER BY random() LIMIT 1)
FROM generate_series(1, 1080) i;

-- Insert data into user_list_v2 (1000+ records across all partitions)
WITH domains AS (
    SELECT unnest(ARRAY[
        'gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com', 'company1.com', 'company2.com', 'company3.com',
        'company4.com', 'company5.com', 'company6.com', 'company7.com', 'company8.com', 'company9.com', 'company10.com',
        'university1.edu', 'university2.edu', 'university3.edu', 'government1.gov', 'government2.gov', 'organization1.org',
        'organization2.org', 'startup1.io', 'startup2.io', 'tech1.tech', 'tech2.tech', 'global.net', 'example.com'
    ]) AS domain_name
)
INSERT INTO user_list_v2 (user_id, username, email)
SELECT 
    i,
    'user_list_v2_' || i,
    'listv2_user' || i || '@' || (SELECT domain_name FROM domains ORDER BY random() LIMIT 1)
FROM generate_series(1, 1080) i;

-- Insert data into user_hash_v1 (1000+ records across all partitions)
INSERT INTO user_hash_v1 (user_id, username, email, hash_key)
SELECT 
    i,
    'user_hash_' || i,
    'hash_user' || i || '@example.com',
    i  -- Let PostgreSQL hash this naturally
FROM generate_series(1, 1080) i;

-- Insert data into user_hash_v2 (1000+ records across all partitions)
INSERT INTO user_hash_v2 (user_id, username, email)
SELECT 
    i,
    'user_hash_v2_' || i,  -- Let PostgreSQL hash the username naturally
    'hashv2_user' || i || '@example.com'
FROM generate_series(1, 1080) i;

-- Insert data into user_multilevel_v1 (1000+ records across all partitions)
INSERT INTO user_multilevel_v1 (user_id, username, email, date_partition, hash_partition)
SELECT 
    i,
    'user_multi_' || i,
    'multi_user' || i || '@example.com',
    ('2024-01-01'::date + ((i % 1095) || ' days')::interval)::date,  -- Spread across 3 years
    i  -- Let PostgreSQL hash this naturally
FROM generate_series(1, 1080) i;

-- Insert data into user_multilevel_v2 (1000+ records across all partitions)
INSERT INTO user_multilevel_v2 (user_id, username, email, created_at)
SELECT 
    i,
    'user_multi_v2_' || i,
    'multiv2_user' || i || '@example.com',
    ('2024-01-01'::timestamp + ((i % 1095) || ' days')::interval + ((i % 86400) || ' seconds')::interval)
FROM generate_series(1, 1080) i;

-- ========================================
-- CREATE INDEXES FOR BETTER PERFORMANCE
-- ========================================

-- Indexes for range tables
CREATE INDEX idx_user_range_v1_user_id ON user_range_v1 (user_id);
CREATE INDEX idx_user_range_v2_user_id ON user_range_v2 (user_id);

-- Indexes for list tables
CREATE INDEX idx_user_list_v1_user_id ON user_list_v1 (user_id);
CREATE INDEX idx_user_list_v2_user_id ON user_list_v2 (user_id);

-- Indexes for hash tables
CREATE INDEX idx_user_hash_v1_user_id ON user_hash_v1 (user_id);
CREATE INDEX idx_user_hash_v2_user_id ON user_hash_v2 (user_id);

-- Indexes for multilevel tables
CREATE INDEX idx_user_multilevel_v1_user_id ON user_multilevel_v1 (user_id);
CREATE INDEX idx_user_multilevel_v2_user_id ON user_multilevel_v2 (user_id);

-- ========================================
-- VERIFY DATA DISTRIBUTION
-- ========================================

\echo '=========================================='
\echo 'Data Distribution Summary'
\echo '=========================================='

SELECT 'user_range_v1' as table_name, COUNT(*) as total_records FROM user_range_v1
UNION ALL
SELECT 'user_range_v2' as table_name, COUNT(*) as total_records FROM user_range_v2
UNION ALL
SELECT 'user_list_v1' as table_name, COUNT(*) as total_records FROM user_list_v1
UNION ALL
SELECT 'user_list_v2' as table_name, COUNT(*) as total_records FROM user_list_v2
UNION ALL
SELECT 'user_hash_v1' as table_name, COUNT(*) as total_records FROM user_hash_v1
UNION ALL
SELECT 'user_hash_v2' as table_name, COUNT(*) as total_records FROM user_hash_v2
UNION ALL
SELECT 'user_multilevel_v1' as table_name, COUNT(*) as total_records FROM user_multilevel_v1
UNION ALL
SELECT 'user_multilevel_v2' as table_name, COUNT(*) as total_records FROM user_multilevel_v2;

\echo '=========================================='
\echo 'Partition Tables Created Successfully!'
\echo 'Ready for testing with evidence scripts.'
\echo '=========================================='