package com.ssf.backend.elearning;

import org.springframework.data.jpa.repository.JpaRepository;

public interface LearningTopicRepository extends JpaRepository<LearningTopic, Long> {
    LearningTopic findByTopicId(String topicId);
}
