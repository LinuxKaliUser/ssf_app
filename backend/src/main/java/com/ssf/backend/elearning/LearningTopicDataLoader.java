package com.ssf.backend.elearning;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.Arrays;

@Configuration
public class LearningTopicDataLoader {
    @Bean
    CommandLineRunner initLearningTopics(LearningTopicRepository topicRepo, QuizQuestionRepository quizRepo) {
        return args -> {
            if (topicRepo.count() == 0) {
                LearningTopic budget = new LearningTopic();
                budget.setTopicId("budget");
                budget.setTitle("Budget-Grundlage");
                budget.setContent("Wie man ein realistisches Monatsbudget erstellt, Rolling Budget, fixe vs. variable Ausgaben, Notgroschen.");
                budget.setProgress(0);

                QuizQuestion q1 = new QuizQuestion();
                q1.setQuestion("Was ist ein Notgroschen?");
                q1.setAnswers(Arrays.asList("Ein Sparkonto für Notfälle", "Ein teures Hobby", "Eine Steuerart"));
                q1.setCorrectIndex(0);
                q1.setLearningTopic(budget);

                QuizQuestion q2 = new QuizQuestion();
                q2.setQuestion("Was zählt zu fixen Ausgaben?");
                q2.setAnswers(Arrays.asList("Miete", "Kino", "Restaurant"));
                q2.setCorrectIndex(0);
                q2.setLearningTopic(budget);

                budget.setQuizQuestions(Arrays.asList(q1, q2));
                topicRepo.save(budget);
                quizRepo.saveAll(Arrays.asList(q1, q2));

                // Add more topics as needed, similar to above
            }
        };
    }
}
