package com.github.diegopacheco.devops.vote.controller;

import com.github.diegopacheco.devops.vote.service.VotingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class VotingController {

    @Autowired
    private VotingService votingService;

    @GetMapping("/vote")
    public String vote(@RequestParam int team) {
        return votingService.vote(team);
    }

    @GetMapping("/check")
    public Map<String, String> check() {
        return votingService.getVotes();
    }
}
