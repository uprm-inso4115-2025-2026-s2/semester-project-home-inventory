import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  Future<Uint8List> generateInventoryStockReportPdfBytes({
    required DateTime startDate,
    required int page,
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> items,
    Uint8List? chartImage,
  }) async {
    final pdf = pw.Document();

    final generatedAt = DateTime.now();
    final endDate = startDate.add(const Duration(days: 6));

    final dateRange =
        '${DateFormat('MMMM d').format(startDate)} - ${DateFormat('d, y').format(endDate)}';

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Inventory Stock Summary',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Report range: $dateRange'),
          pw.Text(
            'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(generatedAt)}',
          ),
          pw.Text('Page: ${page + 1}'),
          pw.SizedBox(height: 24),
          if (chartImage != null) ...[
            pw.Center(
              child: pw.Text(
                'Bar Chart',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Center(
              child: pw.Container(
                constraints: const pw.BoxConstraints(
                  maxWidth: 450,
                  maxHeight: 260,
                ),
                child: pw.Image(
                  pw.MemoryImage(chartImage),
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
          ],
          pw.Text(
            'Category Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const ['Category', 'Quantity'],
            data: categories
                .map((c) => [c['name'], c['quantity'].toString()])
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Items',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const ['Item', 'Category', 'Quantity', 'Status'],
            data: items
                .map(
                  (i) => [
                i['name'],
                i['category'],
                i['quantity'].toString(),
                i['status'],
              ],
            )
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> exportInventoryStockReport({
    required DateTime startDate,
    required int page,
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> items,
    Uint8List? chartImage,
  }) async {
    final pdfBytes = await generateInventoryStockReportPdfBytes(
      startDate: startDate,
      page: page,
      categories: categories,
      items: items,
      chartImage: chartImage,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }

  Future<void> exportExpenditureReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> categories,
    required double totalAmount,
    Uint8List? chartImage,
  }) async {
    final pdf = pw.Document();

    final generatedAt = DateTime.now();
    final dateRange =
        '${DateFormat('MMMM d').format(startDate)} - ${DateFormat('MMMM d, y').format(endDate)}';

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Expenditure Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Report range: $dateRange'),
          pw.Text('Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(generatedAt)}'),
          pw.Text('Total Spent: \$${totalAmount.toStringAsFixed(2)}'),
          pw.SizedBox(height: 24),
          if (chartImage != null) ...[
            pw.Center(
              child: pw.Text(
                'Expenditures by Category',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Center(
              child: pw.Container(
                constraints: const pw.BoxConstraints(
                  maxWidth: 450,
                  maxHeight: 260,
                ),
                child: pw.Image(
                  pw.MemoryImage(chartImage),
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
          ],
          pw.Text(
            'Category Breakdown',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const ['Category', 'Amount (\$)', '% of Total'],
            data: categories
                .map((c) => [
                      c['name'],
                      (c['amount'] as double).toStringAsFixed(2),
                      totalAmount > 0
                          ? '${((c['amount'] as double) / totalAmount * 100).toStringAsFixed(1)}%'
                          : '0%',
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ======================== Item Usage Rates Report ========================

  /// Generates PDF bytes for the Item Usage Rates report
  Future<Uint8List> generateItemUsageRatesReportPdfBytes({
    required String dateRange,
    required List<Map<String, dynamic>> categories,
    Uint8List? chartImage,
  }) async {
    final pdf = pw.Document();

    final generatedAt = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Item Usage Rates Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Report range: $dateRange'),
          pw.Text(
            'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(generatedAt)}',
          ),
          pw.SizedBox(height: 24),
          if (chartImage != null) ...[
            pw.Center(
              child: pw.Text(
                'Weekly Usage Trend',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Center(
              child: pw.Container(
                constraints: const pw.BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 260,
                ),
                child: pw.Image(
                  pw.MemoryImage(chartImage),
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
          ],
          pw.Text(
            'Category Usage Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const ['Category', 'Items Used', 'Usage Rate (%)'],
            data: categories
                .map((c) => [
                      c['name'],
                      c['itemsUsed'].toString(),
                      '${c['usageRate']}%',
                    ])
                .toList(),
          ),
          // Add total row
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total Items Used: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                categories
                    .fold(0, (sum, c) => sum + (c['itemsUsed'] as int))
                    .toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Exports the Item Usage Rates report to PDF
  Future<void> exportItemUsageRatesReport({
    required String dateRange,
    required List<Map<String, dynamic>> categories,
    Uint8List? chartImage,
  }) async {
    final pdfBytes = await generateItemUsageRatesReportPdfBytes(
      dateRange: dateRange,
      categories: categories,
      chartImage: chartImage,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }
}