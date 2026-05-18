package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class App {

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @GetMapping("/")
    public String index() {
        String version = System.getenv().getOrDefault("APP_VERSION", "v1");
        String host = System.getenv().getOrDefault("HOSTNAME", "unknown");
        return "{\"version\":\"" + version + "\",\"hostname\":\"" + host + "\"}";
    }
}
