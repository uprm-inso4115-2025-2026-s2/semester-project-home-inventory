import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:src/features/reports/domain/entities/report_metrics.dart';
import 'package:src/features/reports/domain/repositories/report_repositories.dart';

class SupabaseReportRepository implements ReportRepository {
  final SupabaseClient _client;

  SupabaseReportRepository(this._client);

  @override
  Future<List<Report>> fetchReports() async {
    final response = await _client
        .from('reports')
        .select()
        .order('created_at', ascending: false);
    return response.map((json) => Report.fromJson(json)).toList();
  }

  @override
  Future<List<Report>> searchReports(String query) async {
    if (query.isEmpty) {
      return fetchReports();
    }

    final response = await _client
        .rpc('search_reports', params: {'search_query': query}) as List<dynamic>;

    return response.map((json) => Report.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<Report> fetchReportById(String reportId) async {
    final response = await _client
        .from('reports')
        .select()
        .eq('id', reportId)
        .single();
    return Report.fromJson(response);
  }
}