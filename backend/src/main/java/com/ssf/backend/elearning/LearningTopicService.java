package com.ssf.backend.elearning;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class LearningTopicService {
    private final LearningTopicRepository learningTopicRepository;

    @Autowired
    public LearningTopicService(LearningTopicRepository learningTopicRepository) {
        this.learningTopicRepository = learningTopicRepository;
    }

    public List<LearningTopic> findAll() {
        return learningTopicRepository.findAll();
    }

    public Optional<LearningTopic> findById(Long id) {
        return learningTopicRepository.findById(id);
    }

    public LearningTopic save(LearningTopic topic) {
        return learningTopicRepository.save(topic);
    }

    public void delete(Long id) {
        learningTopicRepository.deleteById(id);
    }
}
