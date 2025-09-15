import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancePlanningScreen extends StatefulWidget {
  const FinancePlanningScreen({super.key});

  @override
  State<FinancePlanningScreen> createState() => _FinancePlanningScreenState();
}

class _FinancePlanningScreenState extends State<FinancePlanningScreen> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController pensionBuyController = TextEditingController();

  List<Map<String, dynamic>> projection = [];

  void calculateProjection() {
    double income = double.tryParse(incomeController.text) ?? 0.0;
    double pensionBuy = double.tryParse(pensionBuyController.text) ?? 0.0;

    List<Map<String, dynamic>> result = [];
    int currentYear = DateTime.now().year;

    for (int i = 0; i < 20; i++) {
      double baseIncome = income * (1 + 0.01 * i); // 1% Wachstum
      double withPensionBuy = baseIncome + pensionBuy;

      // Steuer: 20% vom Einkommen
      double taxWithout = baseIncome * 0.20;
      double taxWith =
          (baseIncome - pensionBuy).clamp(0, double.infinity) * 0.20;

      result.add({
        "year": currentYear + i,
        "income": baseIncome,
        "withPension": withPensionBuy,
        "taxWithout": taxWithout,
        "taxWith": taxWith,
        "savings": taxWithout - taxWith,
      });
    }

    setState(() {
      projection = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finanz- & Steuerplanung")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: incomeController,
              decoration: const InputDecoration(
                labelText: "Jahreseinkommen (CHF)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pensionBuyController,
              decoration: const InputDecoration(
                labelText: "Jährliche PK-Einkäufe (CHF)",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateProjection,
              child: const Text("Simulation starten"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: projection.isEmpty
                  ? const Center(child: Text("Noch keine Simulation gestartet"))
                  : ListView(
                      children: projection.map((row) {
                        return ListTile(
                          title: Text("${row['year']}"),
                          subtitle: Text(
                            "Einkommen: ${row['income'].toStringAsFixed(2)} CHF\n"
                            "Mit PK-Einkäufe: ${row['withPension'].toStringAsFixed(2)} CHF\n"
                            "Steuerersparnis: ${row['savings'].toStringAsFixed(2)} CHF",
                          ),
                        );
                      }).toList(),
                    ),
            ),
            if (projection.isNotEmpty)
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: projection
                            .map(
                              (row) => FlSpot(
                                (row['year'] as int).toDouble(),
                                (row['income'] as double),
                              ),
                            )
                            .toList(),
                        isCurved: true,
                        color: Colors.red,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: projection
                            .map(
                              (row) => FlSpot(
                                (row['year'] as int).toDouble(),
                                (row['withPension'] as double),
                              ),
                            )
                            .toList(),
                        isCurved: true,
                        color: Colors.green,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: projection
                            .map(
                              (row) => FlSpot(
                                (row['year'] as int).toDouble(),
                                (row['savings'] as double),
                              ),
                            )
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
