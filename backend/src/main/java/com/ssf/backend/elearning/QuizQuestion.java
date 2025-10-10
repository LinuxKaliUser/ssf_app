package com.ssf.backend.elearning;

import jakarta.persistence.*;

@Entity
public class QuizQuestion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String question;
    @ElementCollection
    private java.util.List<String> answers;
    private int correctIndex;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "learning_topic_id")
    private LearningTopic learningTopic;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public java.util.List<String> getAnswers() { return answers; }
    public void setAnswers(java.util.List<String> answers) { this.answers = answers; }
    public int getCorrectIndex() { return correctIndex; }
    public void setCorrectIndex(int correctIndex) { this.correctIndex = correctIndex; }
    public LearningTopic getLearningTopic() { return learningTopic; }
    public void setLearningTopic(LearningTopic learningTopic) { this.learningTopic = learningTopic; }
}
