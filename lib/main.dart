import 'package:flutter/material.dart';
import 'package:ssf_app/app_theme.dart';
import 'package:ssf_app/ui/budget_screen.dart';
import 'package:ssf_app/ui/budget_calculator_screen.dart';
import 'package:ssf_app/ui/finance_planning_screen.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatefulWidget {
  const FinanceApp({super.key});

  @override
  State<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    BudgetScreen(),
    BudgetCalculatorScreen(),
    FinancePlanningScreen(),
  ];

  final List<String> _titles = const [
    "�bersicht",
    "Budget Rechner",
    "Finanz- & Steuerplanung",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiss Finance App',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: Text(_titles[_selectedIndex])),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "�bersicht",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: "Rechner",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: "Planung",
            ),
          ],
        ),
      ),
    );
  }
}
