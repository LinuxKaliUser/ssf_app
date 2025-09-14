import 'package:flutter/material.dart';
import 'package:ssf_app/app_routes.dart';
import 'package:ssf_app/app_theme.dart';
import 'package:ssf_app/ui/budget_calculator_screen.dart';
import 'package:ssf_app/ui/budget_screen.dart';

void main() {
  runApp(const FinanceApp());
}


class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiss Finance App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.budget,
      routes: {
        AppRoutes.budget: (_) => const BudgetScreen(),
        AppRoutes.budgetCalculator: (_) => const BudgetCalculatorScreen(),
      },
    );
  }
}

