// Quiz data for each topic
class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;
  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

final Map<String, List<QuizQuestion>> topicQuizzes = {
  'budget': [
    QuizQuestion(
      question: 'Was ist ein Notgroschen?',
      answers: [
        'Ein Sparkonto für Notfälle',
        'Ein teures Hobby',
        'Eine Steuerart',
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Was zählt zu fixen Ausgaben?',
      answers: ['Miete', 'Kino', 'Restaurant'],
      correctIndex: 0,
    ),
  ],
  'sparen': [
    QuizQuestion(
      question: 'Wie kann man die Sparrate erhöhen?',
      answers: [
        'Automatische Überweisung',
        'Mehr ausgeben',
        'Weniger arbeiten',
      ],
      correctIndex: 0,
    ),
  ],
  'invest': [
    QuizQuestion(
      question: 'Was ist Diversifikation?',
      answers: [
        'Verteilung auf verschiedene Anlagen',
        'Alles in eine Aktie',
        'Nur Bargeld halten',
      ],
      correctIndex: 0,
    ),
  ],
  // ... weitere Quizfragen für andere Themen
};
