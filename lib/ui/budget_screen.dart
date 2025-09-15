import 'package:flutter/material.dart';
import 'package:ssf_app/app_routes.dart';
import 'package:ssf_app/domain/transaction_service.dart';

import '../../data/transaction_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TransactionService service = TransactionService();

  void _addTransaction(String title, double amount) {
    final tx = TransactionModel(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );
    setState(() {
      service.addTransaction(tx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mein Budget")),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Total: CHF ${service.totalSpending.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: service.transactions.length,
              itemBuilder: (ctx, i) {
                final tx = service.transactions[i];
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
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "calc",
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.budgetCalculator);
            },
            child: const Icon(Icons.calculate),
          ),
        ],
      ),
    );
  }
}
