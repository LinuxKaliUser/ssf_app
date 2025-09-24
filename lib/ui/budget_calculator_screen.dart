import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssf_app/domain/budget_export_service.dart';
import '../data/budget_category.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  final Function(double income, double expenses)? onUpdate;

  const BudgetCalculatorScreen({super.key, this.onUpdate});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  final TextEditingController incomeController = TextEditingController();
  final BudgetExportService exportService = BudgetExportService();

  late List<BudgetCategory> categories;

  double? result;

  @override
  void initState() {
    super.initState();
    categories = [
      BudgetCategory(
        name: "Wohnen",
        items: [
          BudgetItem(label: "Miete / Hypothek"),
          BudgetItem(label: "Nebenkosten"),
        ],
      ),
      BudgetCategory(
        name: "Ernährung",
        items: [
          BudgetItem(label: "Lebensmittel"),
          BudgetItem(label: "Restaurant / Take-Away"),
        ],
      ),
      BudgetCategory(
        name: "Mobilität",
        items: [
          BudgetItem(label: "ÖV"),
          BudgetItem(label: "Auto (Versicherung, Benzin, Service)"),
        ],
      ),
      BudgetCategory(
        name: "Gesundheit & Versicherungen",
        items: [
          BudgetItem(label: "Krankenkasse"),
          BudgetItem(label: "Zusatzversicherungen"),
          BudgetItem(label: "Medikamente"),
          BudgetItem(label: "Zahnarzt"),
          BudgetItem(label: "Therapie"),
        ],
      ),
      
BudgetCategory(
        name: "Telefon & Internet & TV",
        items: [
          BudgetItem(label: "Internet, TV, Festnetz, Mobil"),
          BudgetItem(label: "Billag Gebühren"),
          BudgetItem(label:   "Streaming Abos (Netflix, Spotify, etc.)"),
        ],
      ),

      BudgetCategory(
        name: "Freizeit & Kultur",
        items: [
          BudgetItem(label: "Ferien"),
          BudgetItem(label: "Hobbys, Sport, Verein, Kino"),
        ],
      ),
       BudgetCategory(
        name: "Weiterbildung & Zeitungen",
        items: [
          BudgetItem(label: "Weitere Bildung"),
          BudgetItem(label: "Zeitungen, Magazine, Bücher, etc."),
        ],
      ),
      BudgetCategory(
        name: "Sparen & Vorsorge",
        items: [
          BudgetItem(label: "Säule 3a"),
          BudgetItem(label: "Wertschriften / Investments"),
        ],
      ),
      BudgetCategory(
        name: "Steuern",
        items: [
          BudgetItem(label: "Gemeindesteuern"),
          BudgetItem(label: "Kantonssteuern"),
          BudgetItem(label: "Bundessteuern"),
          BudgetItem(label: "Quellensteuern"),
          BudgetItem(label: "Wehrpflichtersatz"),
          BudgetItem(label: "Feuerwehrersatzabgabe"),
          BudgetItem(label: "Kirchensteuern"),
        ],
      ),
      BudgetCategory(
        name: "Schulden & Kreditkarten",
        items: [
          BudgetItem(label: "Schulden"),
          BudgetItem(label: "Kreditkarten"),
          BudgetItem(label: "Schuldzinsen"),
          BudgetItem(label: "Kreditkartengebühren & Zinsen"),
        ],
      ),
    ];
  }


  void calculateBudget() {
    double income = double.tryParse(incomeController.text) ?? 0.0;
    double expenses = categories.fold(
      0.0,
      (sum, c) => sum + c.items.fold(0.0, (s, i) => s + i.value),
    );

    setState(() {
      result = income - expenses;
    });

    // Update parent overview with new totals
    widget.onUpdate!(income, expenses);
  }

  Widget _buildCategory(BudgetCategory category) {
    return ExpansionTile(
      title: Text(
        category.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: category.items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            decoration: InputDecoration(labelText: item.label),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() {
                item.value = double.tryParse(val) ?? 0.0;
              });
            },
          ),
        );
      }).toList(),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budgetrechner")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(
              controller: incomeController,
              decoration: const InputDecoration(labelText: "Einkommen"),
              keyboardType: TextInputType.number,
            ),
            ...categories.map((c) => ExpansionTile(
                  title: Text(c.name),
                  children: c.items.map((i) {
                    return TextField(
                      decoration: InputDecoration(labelText: i.label),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        i.value = double.tryParse(val) ?? 0.0;
                      },
                    );
                  }).toList(),
                )),
            ElevatedButton(
              onPressed: calculateBudget,
              child: const Text("Berechnen"),
            ),
             const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async => _exportToExcel(context),
              child: const Text("Als Excel exportieren"),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Text("Saldo: ${result!.toStringAsFixed(2)} CHF"),
          ],
        ),
      ),
    );
  }


  Future<void> _exportToExcel(BuildContext context) async {
    final income = double.tryParse(incomeController.text) ?? 0.0;
    final saldo = result ?? 0.0;
    if (kIsWeb) {
      exportService.exportToExcelWeb(categories, income, saldo);
    } else {
      final file = await exportService.exportToExcel(categories, income, saldo);

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(
        SnackBar(content: Text("Budget exportiert: ${file.path}")),
      );
    }
  }
}
