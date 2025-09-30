import 'package:flutter/material.dart';
import 'package:ssf_app/data/quiz_question.dart';
import 'package:ssf_app/ui/quiz_screen.dart';

class ElearningScreen extends StatefulWidget {
  const ElearningScreen({Key? key}) : super(key: key);

  @override
  State<ElearningScreen> createState() => _ElearningScreenState();
}

class _ElearningScreenState extends State<ElearningScreen> {
  final List<_Topic> _topics = const [
    _Topic(id: 'budget', title: 'Budget-Grundlage'),
    _Topic(id: 'sparen', title: 'Intelligentes Sparen'),
    _Topic(id: 'invest', title: 'Investitions-Grundlagen'),
    _Topic(id: 'steuer', title: 'Steuerplanung'),
    _Topic(id: 'altersvorsorge', title: 'Altersvorsorge'),
    _Topic(id: 'versicherungen', title: 'Versicherungen'),
    _Topic(id: 'immobilien', title: 'Immobilien'),
    _Topic(id: 'dokumenten vorsorge', title: 'Dokumenten Vorsorge'),
    _Topic(id: 'quiz', title: 'Allgemeines Quiz'),
  ];

  // Track which topics are completed and quiz scores per topic
  final Set<String> _completed = <String>{};
  final Map<String, int> _quizScores = {};

  double get _progress =>
      _topics.isEmpty ? 0.0 : _completed.length / _topics.length;

  // Beispielinhalte (kannst du durch Inhalte aus dem Repo ersetzen)
  final Map<String, String> _topicContent = {
    'budget':
        'Wie man ein realistisches Monatsbudget erstellt, fixe vs. variable Ausgaben, Notgroschen.',
    'sparen':
        'Sparstrategien, Sparrate erhöhen, automatische Sparpläne, Notfallreserve.',
    'invest':
        'Grundlagen (Aktien, ETFs, Fonds, Obligationen, Optionen, Bitcoin), Diversifikation, Risiko vs. Rendite, Kosten (TER, Gebühren).',
    'steuer':
        'Grundlagen der Steuererklärung, Abzüge nutzen, Quellensteuer, Steuerplanung für Vorsorge.',
    'altersvorsorge':
        '3-Säulen System CH, Pensionskasse, Säule 3a / 3b, Renten vs. Kapital, Freizügikeitsdepot, AHV.',
    'versicherungen':
        'Wichtige Versicherungen (Haftpflicht, Hausrat, Rechtsschutz, Reiseversicherung, Autoversicherungen).',
    'immobilien':
        'Hypothekenarten, Nebenkosten, Eigenkapital, Tragbarkeit, direkte oder indirekte Amortisation.',
    'dokumenten vorsorge':
        'Wichtige Dokumente Testament, Vorsorgeauftrag, Patientenverfügung.',
  };

  Future<void> _openTopic(BuildContext context, _Topic topic) async {
    // Show detail, then quiz, then mark as completed if quiz passed
    final bool? readDone = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TopicDetailPage(
          title: topic.title,
          content: _topicContent[topic.id] ?? 'Inhalt nicht verfügbar.',
        ),
      ),
    );
    if (readDone == true) {
      // After reading, show quiz
      final quiz = topicQuizzes[topic.id];
      if (quiz != null) {
        final int? score = await Navigator.of(context).push<int>(
          MaterialPageRoute(
            builder: (_) => QuizScreen(title: topic.title, questions: quiz),
          ),
        );
        if (score != null) {
          setState(() {
            _quizScores[topic.id] = score;
            if (score == quiz.length) {
              _completed.add(topic.id);
            }
          });
        }
      } else {
        setState(() {
          _completed.add(topic.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Learning')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Kopf: Fortschritt + kurzer Text
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'E-Learning Modul',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'WÃ¤hle ein Thema aus und arbeite die Lerninhalte durch. Dein Fortschritt wird angezeigt.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: _progress),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_completed.length} / ${_topics.length} abgeschlossen',
                        ),
                        Text('${(_progress * 100).round()} %'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Themenliste
            Expanded(
              child: ListView.separated(
                itemCount: _topics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  if (topic.id == 'quiz') {
                    // Special card for the general quiz module
                    return Card(
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.quiz, color: Colors.blue),
                        title: Text(
                          'Allgemeines Quiz',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Teste dein Wissen zu allen Modulen!',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          // Combine all quiz questions for a general quiz
                          final allQuestions = topicQuizzes.values
                              .expand((q) => q)
                              .toList();
                          final int? score = await Navigator.of(context)
                              .push<int>(
                                MaterialPageRoute(
                                  builder: (_) => QuizScreen(
                                    title: 'Allgemeines Quiz',
                                    questions: allQuestions,
                                  ),
                                ),
                              );
                          if (score != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Du hast $score von ${allQuestions.length} richtig!',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                  final done = _completed.contains(topic.id);
                  final quizScore = _quizScores[topic.id];
                  final quizTotal = topicQuizzes[topic.id]?.length;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(child: Text(topic.title[0])),
                      title: Text(topic.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (_topicContent[topic.id] ?? '').split('.').first +
                                '.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (quizScore != null && quizTotal != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: LinearProgressIndicator(
                                value: quizScore / quizTotal,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                color: quizScore == quizTotal
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                        ],
                      ),
                      trailing: done
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.chevron_right),
                      onTap: () => _openTopic(context, topic),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Topic {
  final String id;
  final String title;
  const _Topic({required this.id, required this.title});
}

class TopicDetailPage extends StatelessWidget {
  final String title;
  final String content;
  const TopicDetailPage({Key? key, required this.title, required this.content})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // kleiner Button, um Thema als erledigt zurï¿½ckzumelden
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Als erledigt markieren',
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
