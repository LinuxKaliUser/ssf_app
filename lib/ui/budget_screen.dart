import 'package:flutter/material.dart';
import 'package:ssf_app/app_routes.dart';
import 'package:ssf_app/domain/transaction_service.dart';

import '../../data/transaction_model.dart';

class BudgetScreen extends StatefulWidget {
  final void Function(double plannedBudget, double actualSpent)? onUpdate;

  const BudgetScreen({super.key, this.onUpdate});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double? _plannedBudget;
  final List<TransactionModel> _transactions = [];

  void _notifyUpdate() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(
        _plannedBudget ?? 0.0,
        _transactions.fold(0.0, (sum, tx) => sum + tx.amount),
      );
    }
  }

  void _setPlannedBudget() async {
    final controller = TextEditingController(
      text: _plannedBudget?.toStringAsFixed(2) ?? '',
    );
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Budget für diesen Monat festlegen'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Geplantes Budget (CHF)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value >= 0) {
                Navigator.of(ctx).pop(value);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _plannedBudget = result;
        _notifyUpdate();
      });
    }
  }

  void _addTransaction() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transaktion hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Betrag (CHF)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(amountController.text);
              if (titleController.text.isNotEmpty && amt != null && amt > 0) {
                setState(() {
                  _transactions.add(
                    TransactionModel(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      amount: amt,
                      date: DateTime.now(),
                    ),
                  );
                  _notifyUpdate();
                });
                Navigator.of(ctx).pop(true);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (result == true) {
      _notifyUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final plannedBudget = _plannedBudget ?? 0.0;
    final totalSpending = _transactions.fold(0.0, (sum, tx) => sum + tx.amount);
    final difference = plannedBudget - totalSpending;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyUpdate();
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Mein Budget")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Geplantes Budget: CHF ${plannedBudget.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Budget festlegen',
                        onPressed: _setPlannedBudget,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Ausgegeben: CHF ${totalSpending.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Differenz: CHF ${difference.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: difference < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, i) {
                final tx = _transactions[i];
                return ListTile(
                  title: Text(tx.title),
                  subtitle: Text(tx.date.toString()),
                  trailing: Text("CHF ${tx.amount.toStringAsFixed(2)}"),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "set_budget",
            backgroundColor: Colors.orange,
            onPressed: _setPlannedBudget,
            tooltip: "Budget festlegen",
            child: const Icon(Icons.account_balance_wallet),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add_tx",
            backgroundColor: Colors.green,
            onPressed: _addTransaction,
            tooltip: "Transaktion hinzufügen",
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
