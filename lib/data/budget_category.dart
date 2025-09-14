class BudgetCategory {
  final String name;
  final List<BudgetItem> items;

  BudgetCategory({required this.name, required this.items});
}

class BudgetItem {
  final String label;
  double value;

  BudgetItem({required this.label, this.value = 0.0});
}
