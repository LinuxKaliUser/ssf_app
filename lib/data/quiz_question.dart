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
        'Ein Sparkonto f�r Notf�lle',
        'Ein teures Hobby',
        'Eine Steuerart',
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Was z�hlt zu fixen Ausgaben?',
      answers: ['Miete', 'Kino', 'Restaurant'],
      correctIndex: 0,
    ),
  ],
  'sparen': [
    QuizQuestion(
      question: 'Wie kann man die Sparrate erh�hen?',
      answers: [
        'Automatische �berweisung',
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
  // ... weitere Quizfragen f�r andere Themen
};
