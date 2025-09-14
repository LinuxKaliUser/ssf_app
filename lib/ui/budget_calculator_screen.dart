import 'package:flutter/material.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController miscController = TextEditingController();

  double? result;

  void calculateBudget() {
    double income = double.tryParse(incomeController.text) ?? 0.0;
    double rent = double.tryParse(rentController.text) ?? 0.0;
    double food = double.tryParse(foodController.text) ?? 0.0;
    double transport = double.tryParse(transportController.text) ?? 0.0;
    double insurance = double.tryParse(insuranceController.text) ?? 0.0;
    double misc = double.tryParse(miscController.text) ?? 0.0;

    double expenses = rent + food + transport + insurance + misc;
    setState(() {
      result = income - expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: incomeController,
              decoration: const InputDecoration(labelText: 'Monthly Income (CHF)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: rentController,
              decoration: const InputDecoration(labelText: 'Rent (CHF)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: foodController,
              decoration: const InputDecoration(labelText: 'Food (CHF)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: transportController,
              decoration: const InputDecoration(labelText: 'Transport (CHF)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: insuranceController,
              decoration: const InputDecoration(labelText: 'Insurances (CHF)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: miscController,
              decoration: const InputDecoration(labelText: 'Miscellaneous (CHF)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBudget,
              child: const Text('Calculate Budget'),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Text(
                'Monthly Balance: ${result!.toStringAsFixed(2)} CHF',
                style: TextStyle(
                  color: result! >= 0 ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
