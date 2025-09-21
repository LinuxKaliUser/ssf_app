import 'package:flutter/material.dart';

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
  ];

  // lokal: welche Themen als erledigt markiert wurden
  final Set<String> _completed = <String>{};

  double get _progress =>
      _topics.isEmpty ? 0.0 : _completed.length / _topics.length;

  // Beispielinhalte (kannst du durch Inhalte aus dem Repo ersetzen)
  static const Map<String, String> _topicContent = {
    'budget':
        'Wie man ein realistisches Monatsbudget erstellt, fixe vs. variable Ausgaben, Notgroschen.',
    'sparen':
        'Sparstrategien, Sparrate erhöhen, automatische Sparpläne, Notfallreserve.',
    'invest':
        'Grundlagen Aktien/ETFs, Diversifikation, Risiko vs. Rendite, Kosten (TER, Gebühren).',
    'steuer':
        'Grundlagen der Steuererklärung, Abzüge nutzen, Quellensteuer, Steuerplanung für Vorsorge.',
    'altersvorsorge':
        '3-Säulen System CH, Pensionskasse, Säule 3a, Renten vs. Kapital.',
  };

  Future<void> _openTopic(BuildContext context, _Topic topic) async {
    // �ffne detailseite; die Seite kann beim Schliessen true zur�ckgeben (markieren als erledigt)
    final bool? completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TopicDetailPage(
          title: topic.title,
          content: _topicContent[topic.id] ?? 'Inhalt nicht verfügbar.',
        ),
      ),
    );

    if (completed == true) {
      setState(() {
        _completed.add(topic.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'E-Learning Modul',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wähle ein Thema aus und arbeite die Lerninhalte durch. Dein Fortschritt wird angezeigt.',
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
                final done = _completed.contains(topic.id);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(child: Text(topic.title[0])),
                    title: Text(topic.title),
                    subtitle: Text(
                      // kurze Vorschau
                      (_topicContent[topic.id] ?? '').split('.').first + '.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
        // kleiner Button, um Thema als erledigt zur�ckzumelden
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
