// Quiz data for each topic
import 'dart:convert';

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;
  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // answers may be a List or a JSON string
    final rawAnswers = json['answers'];
    List<String> parsedAnswers = [];
    if (rawAnswers is List) {
      parsedAnswers = rawAnswers.map((e) => e.toString()).toList();
    } else if (rawAnswers is String) {
      try {
        final decoded = jsonDecode(rawAnswers) as List;
        parsedAnswers = decoded.map((e) => e.toString()).toList();
      } catch (_) {
        // fallback: comma separated
        parsedAnswers = rawAnswers.split(',').map((s) => s.trim()).toList();
      }
    }
    return QuizQuestion(
      question: json['question']?.toString() ?? '',
      answers: parsedAnswers,
      correctIndex: (json['correctIndex'] is int)
          ? json['correctIndex'] as int
          : int.tryParse(json['correctIndex']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answers': answers,
    'correctIndex': correctIndex,
  };

  // final Map<String, List<QuizQuestion>> topicQuizzes = {
  //   'budget': [
  //     QuizQuestion(
  //       question: 'Was ist ein Notgroschen?',
  //       answers: [
  //         'Ein Sparkonto für Notfälle',
  //         'Ein teures Hobby',
  //         'Eine Steuerart',
  //       ],
  //       correctIndex: 0,
  //     ),
  //     QuizQuestion(
  //       question: 'Was zählt zu fixen Ausgaben?',
  //       answers: ['Miete', 'Kino', 'Restaurant'],
  //       correctIndex: 0,
  //     ),
  //   ],
  //   'sparen': [
  //     QuizQuestion(
  //       question: 'Wie kann man die Sparrate erhöhen?',
  //       answers: [
  //         'Automatische Überweisung',
  //         'Mehr ausgeben',
  //         'Weniger arbeiten',
  //       ],
  //       correctIndex: 0,
  //     ),
  //   ],
  //   'invest': [
  //     QuizQuestion(
  //       question: 'Was ist Diversifikation?',
  //       answers: [
  //         'Verteilung auf verschiedene Anlagen',
  //         'Alles in eine Aktie',
  //         'Nur Bargeld halten',
  //       ],
  //       correctIndex: 0,
  //     ),
  //   ],
  //   // ... weitere Quizfragen für andere Themen
  // };
}
