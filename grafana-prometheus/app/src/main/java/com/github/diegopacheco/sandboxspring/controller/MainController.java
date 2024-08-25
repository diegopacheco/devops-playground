package com.github.diegopacheco.sandboxspring.controller;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import reactor.core.publisher.Mono;

import java.util.UUID;

@RestController
public class MainController {

	@RequestMapping("/")
	public String index() {
		return "Greetings from Spring Boot! ID=" + UUID.randomUUID().toString();
	}

	@RequestMapping("/mono")
	public Mono<String> mono() {
		return Mono.just("Greetings from Spring Boot Mono! ID=" + UUID.randomUUID().toString());
	}

	@RequestMapping("/slow/{time}")
	public Mono<String> slow(@PathVariable("time") Long time) {
		try {
			Thread.sleep(time);
		} catch (InterruptedException ignored) {}
		return Mono.just("Greetings from Spring Boot! Slow. ID=" + UUID.randomUUID().toString());
	}

}