import 'package:flutter/material.dart';

class FinancePlanningPage extends StatefulWidget {
  const FinancePlanningPage({Key? key}) : super(key: key);

  @override
  State<FinancePlanningPage> createState() => _FinancePlanningPageState();
}

class _FinancePlanningPageState extends State<FinancePlanningPage> {
  final _formKey = GlobalKey<FormState>();

  // Einnahmen
  final incomeCtrl = TextEditingController(text: '0');
  final nebenerwerbCtrl = TextEditingController(text: '0');
  final ahvCtrl = TextEditingController(text: '0');
  final pkBasisCtrl = TextEditingController(text: '0');
  final pkZusatzCtrl = TextEditingController(text: '0');

  // Ausgaben
  final kkCtrl = TextEditingController(text: '0');
  final ferienCtrl = TextEditingController(text: '0');
  final mieteCtrl = TextEditingController(text: '0');
  final alimenteCtrl = TextEditingController(text: '0');
  final hypothekCtrl = TextEditingController(text: '0');
  final unterhaltCtrl = TextEditingController(text: '0');
  final sauele3aCtrl = TextEditingController(text: '0');
  final einkaufPkBasisCtrl = TextEditingController(text: '0');
  final einkaufPkZusatzCtrl = TextEditingController(text: '0');
  final steuernCtrl = TextEditingController(text: '0');

  // Vorsorgegelder
  final v3a1Ctrl = TextEditingController(text: '0');
  final v3a2Ctrl = TextEditingController(text: '0');
  final v3a3Ctrl = TextEditingController(text: '0');
  final v3a4Ctrl = TextEditingController(text: '0');
  final v3a5Ctrl = TextEditingController(text: '0');
  final steuerVorsorgeCtrl = TextEditingController(text: '0');

  // Liquidit�t
  final liquiditaetKontoCtrl = TextEditingController(text: '0');
  final liquiditaetStartCtrl = TextEditingController(text: '0');
  final kapitalZugaengeCtrl = TextEditingController(text: '0');

  // Computed results
  double totalEinnahmen = 0.0;
  double totalAusgaben = 0.0;
  double differenz = 0.0;
  double totalVorsorge = 0.0;
  double nettoVorsorge = 0.0;
  double steuerBelastungPercent = 0.0;
  double liquiditaetEnde = 0.0;
  double sparquote = 0.0; // Differenz Einnahmen/Ausgaben

  @override
  void dispose() {
    // dispose controllers
    incomeCtrl.dispose();
    nebenerwerbCtrl.dispose();
    ahvCtrl.dispose();
    pkBasisCtrl.dispose();
    pkZusatzCtrl.dispose();
    kkCtrl.dispose();
    ferienCtrl.dispose();
    mieteCtrl.dispose();
    alimenteCtrl.dispose();
    hypothekCtrl.dispose();
    unterhaltCtrl.dispose();
    sauele3aCtrl.dispose();
    einkaufPkBasisCtrl.dispose();
    einkaufPkZusatzCtrl.dispose();
    steuernCtrl.dispose();
    v3a1Ctrl.dispose();
    v3a2Ctrl.dispose();
    v3a3Ctrl.dispose();
    v3a4Ctrl.dispose();
    v3a5Ctrl.dispose();
    steuerVorsorgeCtrl.dispose();
    liquiditaetKontoCtrl.dispose();
    liquiditaetStartCtrl.dispose();
    kapitalZugaengeCtrl.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c) {
    final s = c.text
        .replaceAll("'", '')
        .replaceAll('CHF', '')
        .trim()
        .replaceAll(',', '.');
    return double.tryParse(s) ?? 0.0;
  }

  void _calculateAll() {
    final income = _parse(incomeCtrl);
    final nebenerwerb = _parse(nebenerwerbCtrl);
    final ahv = _parse(ahvCtrl);
    final pkb = _parse(pkBasisCtrl);
    final pkz = _parse(pkZusatzCtrl);

    totalEinnahmen = income + nebenerwerb + ahv + pkb + pkz;

    final kk = _parse(kkCtrl);
    final ferien = _parse(ferienCtrl);
    final miete = _parse(mieteCtrl);
    final alimente = _parse(alimenteCtrl);
    final hypothek = _parse(hypothekCtrl);
    final unterhalt = _parse(unterhaltCtrl);
    final s3a = _parse(sauele3aCtrl);
    final einkaufBasis = _parse(einkaufPkBasisCtrl);
    final einkaufZusatz = _parse(einkaufPkZusatzCtrl);
    final steuern = _parse(steuernCtrl);

    totalAusgaben =
        kk +
        ferien +
        miete +
        alimente +
        hypothek +
        unterhalt +
        s3a +
        einkaufBasis +
        einkaufZusatz +
        steuern;

    differenz = totalEinnahmen - totalAusgaben; // positive = savings
    sparquote = differenz; // for display; you may compute percentage separately

    final v1 = _parse(v3a1Ctrl);
    final v2 = _parse(v3a2Ctrl);
    final v3 = _parse(v3a3Ctrl);
    final v4 = _parse(v3a4Ctrl);
    final v5 = _parse(v3a5Ctrl);
    final steuerVorsorge = _parse(steuerVorsorgeCtrl);

    totalVorsorge = v1 + v2 + v3 + v4 + v5;
    nettoVorsorge = totalVorsorge - steuerVorsorge;
    steuerBelastungPercent = totalVorsorge > 0
        ? (steuerVorsorge / totalVorsorge) * 100.0
        : 0.0;

    final liquidKonto = _parse(liquiditaetKontoCtrl);
    final liquidStart = _parse(liquiditaetStartCtrl);
    final kapitalZ = _parse(kapitalZugaengeCtrl);

    // End liquidity = starting liquidity + capital inflows + savings (differenz)
    liquiditaetEnde = liquidStart + kapitalZ + differenz;

    setState(() {});
  }

  Widget _numberField(String label, TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null; // allow empty
        if (double.tryParse(v.replaceAll("'", '').replaceAll(',', '.')) == null)
          return 'Ungültige Zahl';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Jahres Einnahmen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _numberField('Einkommen', incomeCtrl),
            _numberField('Nebenerwerb', nebenerwerbCtrl),
            _numberField('AHV-Rente', ahvCtrl),
            _numberField('Pensionskasse rente Basis', pkBasisCtrl),
            _numberField('Pensionskasse rente Zusatz', pkZusatzCtrl),
            const SizedBox(height: 12),
            Text(
              'Total Einnahmen ohne Wertschriftenerträge: CHF ${totalEinnahmen.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const Divider(height: 24),
            const Text(
              'Lebenshaltungskosten pro Jahr',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _numberField('Krankenkassenprämien', kkCtrl),
            _numberField('Ferien', ferienCtrl),
            _numberField('Miete', mieteCtrl),
            _numberField('Alimente', alimenteCtrl),
            _numberField('Hypothekarzins Wohnung', hypothekCtrl),
            _numberField(
              'Liegenschaft jährlicher Unterhalt + Nebenkosten',
              unterhaltCtrl,
            ),
            _numberField('Säule 3a', sauele3aCtrl),
            _numberField('Einkauf Pensionskasse basis', einkaufPkBasisCtrl),
            _numberField('Einkauf Pensionskasse Zusatz', einkaufPkZusatzCtrl),
            _numberField('Steuern Bund und Kanton ca.', steuernCtrl),
            const SizedBox(height: 12),
            Text(
              'Totale Ausgaben: CHF ${totalAusgaben.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const Divider(height: 24),
            Text(
              'Differenz Einnahmen/Ausgaben: CHF ${differenz.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 24),
            const Text(
              'Vorsorgegelder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _numberField('Vorsorgekonto 3a 1', v3a1Ctrl),
            _numberField('Vorsorgekonto 3a 2', v3a2Ctrl),
            _numberField('Vorsorgekonto 3a 3', v3a3Ctrl),
            _numberField('Vorsorgekonto 3a 4', v3a4Ctrl),
            _numberField('Vorsorgekonto 3a 5', v3a5Ctrl),
            _numberField(
              'Steuern Bund und Kanton ca. auf Vorsorgekapital',
              steuerVorsorgeCtrl,
            ),

            const SizedBox(height: 8),
            Text(
              'Total Vorsorge: CHF ${totalVorsorge.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Netto Vorsorge (nach Steuern): CHF ${nettoVorsorge.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Steuerbelastung in % der Auszahlung: ${steuerBelastungPercent.toStringAsFixed(2)} %',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const Divider(height: 24),
            const Text(
              'Liquiditätsplanung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _numberField('Liquiditätskonto', liquiditaetKontoCtrl),
            _numberField(
              'Liquidität zu Beginn des Jahres ca.',
              liquiditaetStartCtrl,
            ),
            _numberField('Kapitalzugänge', kapitalZugaengeCtrl),
            const SizedBox(height: 8),
            Text(
              'Liquidität Ende Jahr (ca.): CHF ${liquiditaetEnde.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Differenz Einnahmen/Ausgaben (Sparquote): CHF ${sparquote.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 18),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calculateAll();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berechnungen aktualisiert'),
                        ),
                      );
                    }
                  },
                  child: const Text('Berechnen'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Reset to defaults or empty
                    _resetFields();
                  },
                  child: const Text('Zurücksetzen'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _resetFields() {
    setState(() {
      incomeCtrl.text = '0';
      nebenerwerbCtrl.text = '0';
      ahvCtrl.text = '0';
      pkBasisCtrl.text = '0';
      pkZusatzCtrl.text = '0';

      kkCtrl.text = '0';
      ferienCtrl.text = '0';
      mieteCtrl.text = '0';
      alimenteCtrl.text = '0';
      hypothekCtrl.text = '0';
      unterhaltCtrl.text = '0';
      sauele3aCtrl.text = '0';
      einkaufPkBasisCtrl.text = '0';
      einkaufPkZusatzCtrl.text = '0';
      steuernCtrl.text = '0';

      v3a1Ctrl.text = '0';
      v3a2Ctrl.text = '0';
      v3a3Ctrl.text = '0';
      v3a4Ctrl.text = '0';
      v3a5Ctrl.text = '0';
      steuerVorsorgeCtrl.text = '0';

      liquiditaetKontoCtrl.text = '0';
      liquiditaetStartCtrl.text = '0';
      kapitalZugaengeCtrl.text = '0';

      totalEinnahmen = 0;
      totalAusgaben = 0;
      differenz = 0;
      totalVorsorge = 0;
      nettoVorsorge = 0;
      steuerBelastungPercent = 0;
      liquiditaetEnde = 0;
      sparquote = 0;
    });
  }
}
