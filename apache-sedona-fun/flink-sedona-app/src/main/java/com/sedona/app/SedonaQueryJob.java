package com.sedona.app;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;
import org.apache.flink.api.common.RuntimeExecutionMode;
import org.apache.sedona.flink.SedonaContext;

public class SedonaQueryJob {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setRuntimeMode(RuntimeExecutionMode.BATCH);
        env.setParallelism(1);
        
        StreamTableEnvironment tableEnv = StreamTableEnvironment.create(env);
        SedonaContext.create(env, tableEnv);

        System.out.println("=== Apache Sedona Ultra-Simple Test ===");
        long startTime = System.currentTimeMillis();

        Table result = tableEnv.sqlQuery(
            "SELECT ST_AsText(ST_Point(1.0, 2.0)) as point_text"
        );

        result.execute();
        
        long endTime = System.currentTimeMillis();
        System.out.println("=== ✅ SUCCESS! Sedona query executed ===");
        System.out.println("=== Completed in " + (endTime - startTime) + "ms ===");
        System.out.println("=== Expected: POINT (1 2) ===");
    }
}
