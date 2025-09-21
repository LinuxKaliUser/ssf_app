import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function(String, double) onAdd;

  const AddTransactionScreen({super.key, required this.onAdd});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submit() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (title.isEmpty || amount <= 0) return;

    widget.onAdd(title, amount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neue Ausgabe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Titel"),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Betrag (CHF)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Hinzufügen"),
            ),
          ],
        ),
      ),
    );
  }
}
