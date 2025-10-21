package com.ssf.backend.elearning;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/elearning/topics")
public class LearningTopicController {
    private final LearningTopicService learningTopicService;

    @Autowired
    public LearningTopicController(LearningTopicService learningTopicService) {
        this.learningTopicService = learningTopicService;
    }

    @GetMapping
    public List<LearningTopic> all() {
        System.out.println(learningTopicService.findAll());
        return learningTopicService.findAll();
    }

    // add this method to controller
    @GetMapping("/by-topic-id/{topicId}")
    public ResponseEntity<LearningTopic> byTopicId(@PathVariable String topicId) {
        return learningTopicService.findByTopicId(topicId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}")
    public ResponseEntity<LearningTopic> byId(@PathVariable Long id) {
        return learningTopicService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public LearningTopic create(@RequestBody LearningTopic topic) {
        return learningTopicService.save(topic);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        learningTopicService.delete(id);
    }
}
