import 'package:flutter/material.dart';
import 'package:ssf_app/data/quiz_question.dart';
import 'package:ssf_app/data/quiz_question.dart';
import 'package:ssf_app/ui/elearning_screen.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  const QuizScreen({Key? key, required this.title, required this.questions})
    : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _current = 0;
  int _score = 0;
  List<int?> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers = List<int?>.filled(widget.questions.length, null);
  }

  void _next() {
    if (_answers[_current] == widget.questions[_current].correctIndex) {
      _score++;
    }
    if (_current < widget.questions.length - 1) {
      setState(() {
        _current++;
      });
    } else {
      Navigator.of(context).pop(_score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_current];
    return Scaffold(
      appBar: AppBar(title: Text('Quiz: ${widget.title}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Frage ${_current + 1} von ${widget.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(q.question, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ...List.generate(
              q.answers.length,
              (i) => RadioListTile<int>(
                value: i,
                groupValue: _answers[_current],
                onChanged: (val) {
                  setState(() {
                    _answers[_current] = val;
                  });
                },
                title: Text(q.answers[i]),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _answers[_current] != null ? _next : null,
              child: Text(
                _current < widget.questions.length - 1 ? 'Weiter' : 'Fertig',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
