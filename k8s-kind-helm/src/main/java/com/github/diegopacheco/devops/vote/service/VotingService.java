package com.github.diegopacheco.devops.vote.service;

import io.lettuce.core.RedisClient;
import io.lettuce.core.api.StatefulRedisConnection;
import io.lettuce.core.api.sync.RedisCommands;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.util.HashMap;
import java.util.Map;

@Service
public class VotingService {

    @Value("${spring.redis.host}")
    private String redisHost;

    @Value("${spring.redis.port}")
    private int redisPort;

    private RedisClient redisClient;
    private StatefulRedisConnection<String, String> connection;
    private RedisCommands<String, String> commands;

    private static final String[] TEAMS = {"warriors", "lakers", "bucks", "okc"};

    @PostConstruct
    public void init() {
        redisClient = RedisClient.create("redis://" + redisHost + ":" + redisPort);
        connection = redisClient.connect();
        commands = connection.sync();
    }

    @PreDestroy
    public void cleanup() {
        if (connection != null) {
            connection.close();
        }
        if (redisClient != null) {
            redisClient.shutdown();
        }
    }

    public String vote(int team) {
        if (team < 1 || team > 4) {
            return "Invalid team. Choose 1-4";
        }
        String teamName = TEAMS[team - 1];
        commands.incr(teamName);
        return "Voted for " + teamName;
    }

    public Map<String, String> getVotes() {
        Map<String, String> votes = new HashMap<>();
        for (String team : TEAMS) {
            String count = commands.get(team);
            votes.put(team, count != null ? count : "0");
        }
        return votes;
    }
}
