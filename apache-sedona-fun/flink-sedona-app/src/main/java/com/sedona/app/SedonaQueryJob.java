package com.sedona.app;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;
import org.apache.sedona.flink.SedonaContext;

public class SedonaQueryJob {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);
        
        StreamTableEnvironment tableEnv = StreamTableEnvironment.create(env);
        SedonaContext.create(env, tableEnv);

        System.out.println("=== Apache Sedona Simple Spatial Query Test ===");
        long startTime = System.currentTimeMillis();

        Table result = tableEnv.sqlQuery(
            "SELECT " +
            "  ST_AsText(ST_GeomFromText('POINT(1 2)')) as point_wkt, " +
            "  ST_Area(ST_GeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))')) as polygon_area, " +
            "  ST_Distance(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('POINT(3 4)')) as point_distance"
        );

        result.execute().print();
        
        long endTime = System.currentTimeMillis();
        System.out.println("=== Query completed in " + (endTime - startTime) + "ms ===");
        System.out.println("=== Results: POINT(1 2), Area=100.0, Distance=5.0 ===");
    }
}
