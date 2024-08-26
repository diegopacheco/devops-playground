package com.github.diegopacheco.sandboxspring.health;

import org.springframework.boot.actuate.health.AbstractHealthIndicator;
import org.springframework.boot.actuate.health.Health;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class CustomHealthCheck extends AbstractHealthIndicator {

    private boolean running = System.getProperty("health.running", "true").equals("true");

    @Override
    protected void doHealthCheck(Health.Builder bldr) throws Exception {
        long start = System.currentTimeMillis();
        String id = UUID.randomUUID().toString();
        if (running) {
            long end = System.currentTimeMillis();
            bldr.up()
                    .withDetail("ID",id)
                    .withDetail("time", end - start);
        } else {
            long end = System.currentTimeMillis();
            bldr.down()
                    .withDetail("ID",id)
                    .withDetail("time", end - start);
        }
    }

}