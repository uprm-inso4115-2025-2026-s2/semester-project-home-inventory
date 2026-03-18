import '../entities/report_metrics.dart';

abstract class ReportRepository {
  Future<List<Report>> fetchReports();

  Future<List<Report>> searchReports(String query);

  Future<Report> fetchReportById(String reportId);
}
