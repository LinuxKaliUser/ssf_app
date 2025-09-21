import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../data/budget_category.dart';

class BudgetExportService {
  /// Export Excel for **mobile/desktop** (saves to filesystem)
  Future<File> exportToExcel(
    List<BudgetCategory> categories,
    double income,
    double result,
  ) async {
    final excel = _buildExcel(categories, income, result);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/budget_export.xlsx";
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return file;
  }

  /// Export Excel for **web** (downloads file in browser)
  void exportToExcelWeb(
    List<BudgetCategory> categories,
    double income,
    double result,
  ) {
    final excel = _buildExcel(categories, income, result);

    final Uint8List bytes = Uint8List.fromList(excel.encode()!);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "budget_export.xlsx")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  /// Shared method to build the Excel file contents
  Excel _buildExcel(
    List<BudgetCategory> categories,
    double income,
    double result,
  ) {
    final excel = Excel.createExcel();
    final sheet = excel['Budget'];

    // Titel
    sheet.appendRow(["Budget Übersicht"]);
    sheet.appendRow([]);

    // Einkommen
    sheet.appendRow(["Monatliches Einkommen", income]);

    // Kategorien + Items
    sheet.appendRow([]);
    sheet.appendRow(["Kategorie", "Posten", "Betrag (CHF)"]);

    for (var category in categories) {
      for (var item in category.items) {
        sheet.appendRow([category.name, item.label, item.value]);
      }
    }

    // Saldo
    sheet.appendRow([]);
    sheet.appendRow(["Monatlicher Saldo", result.toStringAsFixed(2)]);

    return excel;
  }
}
