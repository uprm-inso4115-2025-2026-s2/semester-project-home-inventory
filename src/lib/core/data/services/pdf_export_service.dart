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
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(1),
            },
            headers: const ['Category', 'Quantity'],
            data: categories
                .map((c) => [
                      (c['name'] ?? '').toString(),
                      (c['quantity'] ?? 0).toString(),
                    ])
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
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(2),
            },
            headers: const ['Item', 'Category', 'Qty', 'Status'],
            data: items
                .map((i) => [
                      (i['name'] ?? '').toString(),
                      (i['category'] ?? '').toString(),
                      (i['quantity'] ?? 0).toString(),
                      (i['status'] ?? '').toString(),
                    ])
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

  Future<Uint8List> generateExpenditureReportPdfBytes({
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
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
            },
            headers: const ['Category', 'Amount (\$)', '% of Total'],
            data: categories
                .map((c) {
                  final amount = (c['amount'] as num?)?.toDouble() ?? 0.0;
                  return [
                    (c['name'] ?? '').toString(),
                    amount.toStringAsFixed(2),
                    totalAmount > 0
                        ? '${(amount / totalAmount * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ];
                })
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> exportExpenditureReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> categories,
    required double totalAmount,
    Uint8List? chartImage,
  }) async {
    final pdfBytes = await generateExpenditureReportPdfBytes(
      startDate: startDate,
      endDate: endDate,
      categories: categories,
      totalAmount: totalAmount,
      chartImage: chartImage,
    );
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
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
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
            },
            headers: const ['Category', 'Items Used', 'Usage Rate (%)'],
            data: categories
                .map((c) => [
                      (c['name'] ?? '').toString(),
                      (c['itemsUsed'] ?? 0).toString(),
                      '${c['usageRate'] ?? 0}%',
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