import 'package:ssf_app/ui/overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:ssf_app/app_theme.dart';
import 'package:ssf_app/ui/budget_home.dart';
import 'package:ssf_app/ui/budget_screen.dart';
import 'package:ssf_app/ui/budget_calculator_screen.dart';
import 'package:ssf_app/ui/elearning_screen.dart';
import 'package:ssf_app/ui/finance_plan_form.dart';
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

  final List<Widget> _screens = [
    OverviewScreen(),
    const BudgetHome(),
    const FinancePlanningScreen(),
    const ElearningScreen(),
  ];

  final List<String> _titles = const [
    "�bersicht",
    "Budget",
    "Finanz- & Steuerplanung",
    "E-Learning",
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
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              icon: Icon(Icons.dashboard),
              label: "�bersicht",
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              icon: Icon(Icons.calculate),
              label: "Budget",
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              icon: Icon(Icons.assessment),
              label: "Planung",
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              icon: Icon(Icons.school),
              label: "E-Learning",
            ),
          ],
        ),
      ),
    );
  }
}
