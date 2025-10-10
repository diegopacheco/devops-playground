package com.example.otel;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@RestController
public class MetricsController {
    private final Counter requestCounter;
    private final Timer requestTimer;
    private final Random random = new Random();

    public MetricsController(MeterRegistry registry) {
        this.requestCounter = Counter.builder("http_requests_total")
                .description("Total HTTP requests")
                .register(registry);
        this.requestTimer = Timer.builder("http_request_duration")
                .description("HTTP request duration")
                .register(registry);
    }

    @GetMapping("/")
    public String home() {
        requestCounter.increment();
        return requestTimer.record(() -> {
            simulateWork();
            return "OpenTelemetry Application Running";
        });
    }

    @GetMapping("/api/data")
    public String getData() {
        requestCounter.increment();
        return requestTimer.record(() -> {
            simulateWork();
            return "{\"status\":\"success\",\"data\":[1,2,3,4,5]}";
        });
    }

    @GetMapping("/api/health")
    public String health() {
        return "{\"status\":\"healthy\"}";
    }

    private void simulateWork() {
        try {
            TimeUnit.MILLISECONDS.sleep(random.nextInt(100));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
