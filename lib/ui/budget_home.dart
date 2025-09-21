import 'package:flutter/material.dart';
import 'budget_calculator_screen.dart';
import 'budget_screen.dart';

class BudgetHome extends StatefulWidget {
  const BudgetHome({super.key});

  @override
  State<BudgetHome> createState() => _BudgetHomeState();
}

class _BudgetHomeState extends State<BudgetHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double _budgetIncome = 0.0;
  double _budgetExpenses = 0.0;

  double _calcIncome = 0.0;
  double _calcExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void updateFromBudget(double income, double expenses) {
    setState(() {
      _budgetIncome = income;
      _budgetExpenses = expenses;
    });
  }

  void updateFromCalculator(double income, double expenses) {
    setState(() {
      _calcIncome = income;
      _calcExpenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finanzplanung"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Mein Budget"),
            Tab(text: "Budgetrechner"),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Finanzübersicht",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryCard(
                        title: "Budget",
                        income: _budgetIncome,
                        expenses: _budgetExpenses,
                      ),
                      _buildSummaryCard(
                        title: "Rechner",
                        income: _calcIncome,
                        expenses: _calcExpenses,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BudgetScreen(onUpdate: updateFromBudget),
                BudgetCalculatorScreen(onUpdate: updateFromCalculator),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSummaryCard({
  required String title,
  required double income,
  required double expenses,
}) {
  final diff = income - expenses;
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_downward, color: Colors.green, size: 18),
              Text("CHF ${income.toStringAsFixed(2)}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_upward, color: Colors.red, size: 18),
              Text("CHF ${expenses.toStringAsFixed(2)}"),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Diff: CHF ${diff.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: diff >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}
