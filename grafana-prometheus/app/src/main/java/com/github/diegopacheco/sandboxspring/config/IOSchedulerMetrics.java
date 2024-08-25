package com.github.diegopacheco.sandboxspring.config;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.binder.MeterBinder;
import org.springframework.stereotype.Component;
import reactor.core.scheduler.Schedulers;

@Component
public class IOSchedulerMetrics implements MeterBinder {

    @Override
    public void bindTo(MeterRegistry registry) {
        Schedulers.enableMetrics();
    }

}