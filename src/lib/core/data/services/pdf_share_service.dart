import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class PdfShareResult {
  final String storagePath;
  final String signedUrl;

  const PdfShareResult({
    required this.storagePath,
    required this.signedUrl,
  });
}

class PdfShareService {
  PdfShareService();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<PdfShareResult> uploadPdfAndCreateSignedUrl({
    required Uint8List pdfBytes,
    required String fileName,
    required String reportType,
    int expiresInSeconds = 3600,
  }) async {
    final user = _supabase.auth.currentUser;
    final ownerFolder = user?.id ?? 'test-user';

    final sanitizedReportType = reportType
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_-]'), '_');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath =
        '$ownerFolder/$sanitizedReportType/${timestamp}_$fileName';

    await _supabase.storage.from('reports').uploadBinary(
      storagePath,
      pdfBytes,
      fileOptions: const FileOptions(
        contentType: 'application/pdf',
        upsert: false,
      ),
    );

    final signedUrl = await _supabase.storage
        .from('reports')
        .createSignedUrl(storagePath, expiresInSeconds);

    return PdfShareResult(
      storagePath: storagePath,
      signedUrl: signedUrl,
    );
  }
}