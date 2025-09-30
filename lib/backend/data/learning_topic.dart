import 'package:ssf_app/data/quiz_question.dart';

class LearningTopic {
  final String id;
  final String title;
  final String content;
  final List<QuizQuestion> quizQuestions;
  int progress; // 0-100

  LearningTopic({
    required this.id,
    required this.title,
    required this.content,
    required this.quizQuestions,
    this.progress = 0,
  });
}
