import 'package:flutter/material.dart';
import 'package:ssf_app/data/modul_info.dart';
import 'budget_home.dart';
import 'finance_planning_screen.dart';
import 'elearning_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      ModuleInfo(
        name: 'Budget',
        icon: Icons.calculate,
        description: 'Mein Budget und Budgetrechner',
        widget: const BudgetHome(),
      ),
      ModuleInfo(
        name: 'Finanz- & Steuerplanung',
        icon: Icons.assessment,
        description: 'Simulation und Planungsformular',
        widget: const FinancePlanningScreen(),
      ),
      ModuleInfo(
        name: 'E-Learning',
        icon: Icons.school,
        description: 'Finanzwissen & Tutorials',
        widget: const ElearningScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Übersicht')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, idx) {
          final m = modules[idx];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(m.icon, size: 32),
              title: Text(
                m.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(m.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => m.widget));
              },
            ),
          );
        },
      ),
    );
  }
}
