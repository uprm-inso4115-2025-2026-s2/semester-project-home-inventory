import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pdf_export_service.dart';
import 'pdf_share_service.dart';

class PdfShareHelper {
  PdfShareHelper._();

  static Future<void> shareInventoryReport({
    required BuildContext context,
    required DateTime startDate,
    required int page,
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> items,
    Uint8List? chartImage,
    String fileName = 'inventory_stock_report.pdf',
    String reportType = 'inventory_stock',
  }) async {
    try {
      final pdfExportService = PdfExportService();
      final pdfShareService = PdfShareService();

      final pdfBytes =
      await pdfExportService.generateInventoryStockReportPdfBytes(
        startDate: startDate,
        page: page,
        categories: categories,
        items: items,
        chartImage: chartImage,
      );

      final result = await pdfShareService.uploadPdfAndCreateSignedUrl(
        pdfBytes: pdfBytes,
        fileName: fileName,
        reportType: reportType,
        expiresInSeconds: 3600,
      );

      if (!context.mounted) return;

      await _showShareDialog(context, result.signedUrl);
    } catch (e) {
      debugPrint('PDF SHARE ERROR: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }

  static Future<void> shareExpenditureReport({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> categories,
    required double totalAmount,
    Uint8List? chartImage,
    String fileName = 'expenditure_report.pdf',
    String reportType = 'expenditure',
  }) async {
    try {
      final pdfExportService = PdfExportService();
      final pdfShareService = PdfShareService();

      final pdfBytes = await pdfExportService.generateExpenditureReportPdfBytes(
        startDate: startDate,
        endDate: endDate,
        categories: categories,
        totalAmount: totalAmount,
        chartImage: chartImage,
      );

      final result = await pdfShareService.uploadPdfAndCreateSignedUrl(
        pdfBytes: pdfBytes,
        fileName: fileName,
        reportType: reportType,
        expiresInSeconds: 3600,
      );

      if (!context.mounted) return;

      await _showShareDialog(context, result.signedUrl);
    } catch (e) {
      debugPrint('PDF SHARE ERROR: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }

  static Future<void> shareItemUsageRatesReport({
    required BuildContext context,
    required String dateRange,
    required List<Map<String, dynamic>> categories,
    Uint8List? chartImage,
    String fileName = 'item_usage_rates_report.pdf',
    String reportType = 'item_usage_rates',
  }) async {
    try {
      final pdfExportService = PdfExportService();
      final pdfShareService = PdfShareService();

      final pdfBytes = await pdfExportService.generateItemUsageRatesReportPdfBytes(
        dateRange: dateRange,
        categories: categories,
        chartImage: chartImage,
      );

      final result = await pdfShareService.uploadPdfAndCreateSignedUrl(
        pdfBytes: pdfBytes,
        fileName: fileName,
        reportType: reportType,
        expiresInSeconds: 3600,
      );

      if (!context.mounted) return;

      await _showShareDialog(context, result.signedUrl);
    } catch (e) {
      debugPrint('PDF SHARE ERROR: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }

  static Future<void> _showShareDialog(
      BuildContext context,
      String signedUrl,
      ) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('PDF Share Link Ready'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your link is ready.'),
              SizedBox(height: 8),
              Text('It will expire in 1 hour.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: signedUrl));

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(signedUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: const Text('Open'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}