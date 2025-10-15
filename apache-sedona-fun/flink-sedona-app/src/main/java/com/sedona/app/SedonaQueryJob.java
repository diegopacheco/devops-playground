package com.sedona.app;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;
import org.apache.sedona.flink.SedonaContext;

public class SedonaQueryJob {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        StreamTableEnvironment tableEnv = StreamTableEnvironment.create(env);

        SedonaContext.create(env, tableEnv);

        System.out.println("=== Apache Sedona Spatial Query Tests ===");

        Table result = tableEnv.sqlQuery(
            "SELECT " +
            "  'Test 1: Geometries' as test_name, " +
            "  ST_AsText(ST_GeomFromText('POINT(1 2)')) as point, " +
            "  ST_AsText(ST_GeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))')) as polygon " +
            "UNION ALL SELECT " +
            "  'Test 2: Area' as test_name, " +
            "  CAST(ST_Area(ST_GeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))')) AS STRING) as point, " +
            "  'Area = 100.0' as polygon " +
            "UNION ALL SELECT " +
            "  'Test 3: Distance' as test_name, " +
            "  CAST(ST_Distance(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('POINT(3 4)')) AS STRING) as point, " +
            "  'Distance = 5.0' as polygon " +
            "UNION ALL SELECT " +
            "  'Test 4: Contains' as test_name, " +
            "  CAST(ST_Contains(ST_GeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))'), ST_GeomFromText('POINT(5 5)')) AS STRING) as point, " +
            "  'Contains = true' as polygon " +
            "UNION ALL SELECT " +
            "  'Test 5: Buffer' as test_name, " +
            "  SUBSTRING(ST_AsText(ST_Buffer(ST_GeomFromText('POINT(0 0)'), 5.0)), 1, 20) as point, " +
            "  'Buffer created' as polygon"
        );

        result.execute().print();

        System.out.println("=== All Sedona spatial query tests completed! ===");
    }
}
