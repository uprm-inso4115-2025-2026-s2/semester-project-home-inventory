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
}