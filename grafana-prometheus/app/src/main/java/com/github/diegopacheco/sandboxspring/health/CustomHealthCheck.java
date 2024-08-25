package com.github.diegopacheco.sandboxspring.health;

import org.springframework.boot.actuate.health.AbstractHealthIndicator;
import org.springframework.boot.actuate.health.Health;
import org.springframework.stereotype.Component;

@Component
public class CustomHealthCheck extends AbstractHealthIndicator {

    private boolean running = System.getProperty("health.running", "true").equals("true");

    @Override
    protected void doHealthCheck(Health.Builder bldr) throws Exception {
        if (running) {
            bldr.up();
        } else {
            bldr.down();
        }
    }

}