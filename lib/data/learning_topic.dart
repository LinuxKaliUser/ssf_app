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

  factory LearningTopic.fromJson(Map<String, dynamic> json) {
    // backend may send 'topicId' or 'id' (numeric). Normalize to string id.
    String idVal = '';
    if (json.containsKey('topicId')) {
      idVal = json['topicId']?.toString() ?? '';
    } else if (json.containsKey('id')) {
      idVal = json['id']?.toString() ?? '';
    } else if (json.containsKey('topic_id')) {
      idVal = json['topic_id']?.toString() ?? '';
    }

    final quizRaw =
        json['quizQuestions'] ??
        json['quiz_questions'] ??
        json['questions'] ??
        [];
    List<QuizQuestion> questions = [];
    if (quizRaw is List) {
      questions = quizRaw.map((e) {
        if (e is Map<String, dynamic>) return QuizQuestion.fromJson(e);
        if (e is Map)
          return QuizQuestion.fromJson(Map<String, dynamic>.from(e));
        return QuizQuestion(question: '', answers: [], correctIndex: 0);
      }).toList();
    }

    return LearningTopic(
      id: idVal,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      quizQuestions: questions,
      progress: (json['progress'] is int)
          ? json['progress'] as int
          : int.tryParse(json['progress']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'topicId': id,
    'title': title,
    'content': content,
    'progress': progress,
    'quizQuestions': quizQuestions.map((q) => q.toJson()).toList(),
  };
}
