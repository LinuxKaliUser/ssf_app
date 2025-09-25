import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ssf_app/app_theme.dart';
import 'finance_plan_form.dart';

class FinancePlanningScreen extends StatefulWidget {
  const FinancePlanningScreen({super.key});

  @override
  State<FinancePlanningScreen> createState() => _FinancePlanningScreenState();
}

class _FinancePlanningScreenState extends State<FinancePlanningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulation tab state
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController pensionBuyController = TextEditingController();
  final TextEditingController federalRateController = TextEditingController(
    text: "6.0",
  );
  final TextEditingController cantonRateController = TextEditingController(
    text: "10.0",
  );
  final TextEditingController communalRateController = TextEditingController(
    text: "4.0",
  );

  List<Map<String, dynamic>> projection = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    incomeController.dispose();
    pensionBuyController.dispose();
    federalRateController.dispose();
    cantonRateController.dispose();
    communalRateController.dispose();
    super.dispose();
  }

  void calculateProjection() {
    double income = double.tryParse(incomeController.text) ?? 0.0;
    double pensionBuy = double.tryParse(pensionBuyController.text) ?? 0.0;

    double federalRate =
        (double.tryParse(federalRateController.text) ?? 0.0) / 100.0;
    double cantonRate =
        (double.tryParse(cantonRateController.text) ?? 0.0) / 100.0;
    double communalRate =
        (double.tryParse(communalRateController.text) ?? 0.0) / 100.0;

    List<Map<String, dynamic>> result = [];
    int currentYear = DateTime.now().year;

    for (int i = 0; i < 20; i++) {
      double baseIncome =
          income; // for later to calucalte inflationar growth* (1 + 0.01 * i); // 1% Wachstum
      double withPensionBuy = baseIncome - pensionBuy;

      // taxes without pensionBuy
      double taxFederalWithout = baseIncome * federalRate;
      double taxCantonWithout = baseIncome * cantonRate;
      double taxCommunalWithout = baseIncome * communalRate;
      double totalTaxWithout =
          taxFederalWithout + taxCantonWithout + taxCommunalWithout;

      // taxes with pensionBuy (taxable income reduced by pensionBuy)
      double taxableWith = (baseIncome - pensionBuy).clamp(0, double.infinity);
      double taxFederalWith = taxableWith * federalRate;
      double taxCantonWith = taxableWith * cantonRate;
      double taxCommunalWith = taxableWith * communalRate;
      double totalTaxWith = taxFederalWith + taxCantonWith + taxCommunalWith;

      double savings = totalTaxWithout - totalTaxWith;

      result.add({
        "year": currentYear + i,
        "income": baseIncome,
        "withPension": withPensionBuy,
        "taxFederalWithout": taxFederalWithout,
        "taxCantonWithout": taxCantonWithout,
        "taxCommunalWithout": taxCommunalWithout,
        "taxFederalWith": taxFederalWith,
        "taxCantonWith": taxCantonWith,
        "taxCommunalWith": taxCommunalWith,
        "totalTaxWithout": totalTaxWithout,
        "totalTaxWith": totalTaxWith,
        "savings": savings,
      });
    }

    setState(() {
      projection = result;
    });
  }

  Widget _buildSimulationTab() {
    // helper to build small percent input
    Widget percentField(String label, TextEditingController ctrl) {
      return Expanded(
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
        ),
      );
    }

    double totalSavingsAccumulated = projection.fold(
      0.0,
      (sum, row) => sum + (row['savings'] as double? ?? 0.0),
    );

    return Padding(
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
              labelText: "Jährliche Einkäufe 3a (CHF)",
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              percentField("Bundessteuer (%)", federalRateController),
              const SizedBox(width: 8),
              percentField("Kanton (%)", cantonRateController),
              const SizedBox(width: 8),
              percentField("Gemeinde (%)", communalRateController),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculateProjection,
            child: const Text("Simulation starten"),
          ),
          const SizedBox(height: 12),
          if (projection.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Total Einsparung Steuern (über alle Jahre): ${totalSavingsAccumulated.toStringAsFixed(2)} CHF",
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: projection.isEmpty
                ? const Center(child: Text("Noch keine Simulation gestartet"))
                : ListView(
                    children: projection.map((row) {
                      return ListTile(
                        title: Text("${row['year']}"),
                        subtitle: Text(
                          "Einkommen: ${row['income'].toStringAsFixed(2)} CHF\n"
                          "Mit 3a Einzahlungen: ${row['withPension'].toStringAsFixed(2)} CHF\n"
                          "Steuern ohne 3a - Bund: ${row['taxFederalWithout'].toStringAsFixed(2)} CHF, Kanton: ${row['taxCantonWithout'].toStringAsFixed(2)} CHF, Gemeinde: ${row['taxCommunalWithout'].toStringAsFixed(2)} CHF\n"
                          "Steuern mit 3a   - Bund: ${row['taxFederalWith'].toStringAsFixed(2)} CHF, Kanton: ${row['taxCantonWith'].toStringAsFixed(2)} CHF, Gemeinde: ${row['taxCommunalWith'].toStringAsFixed(2)} CHF\n"
                          "Gesamteinsparung: ${row['savings'].toStringAsFixed(2)} CHF",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finanzplanung & Simulation"),
        bottom: TabBar(
          labelColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
          unselectedLabelColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          controller: _tabController,
          tabs: const [
            Tab(text: "Simulation"),
            Tab(text: "Planer"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimulationTab(),
          FinancePlanningPage(), // from finance_plan_form.dart
        ],
      ),
    );
  }
}
