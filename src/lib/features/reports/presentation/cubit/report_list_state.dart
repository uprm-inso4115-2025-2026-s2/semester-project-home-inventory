part of 'report_list_cubit.dart';

abstract class ReportListState {}

class ReportListInitial extends ReportListState {}

class ReportListLoading extends ReportListState {}

class ReportListLoaded extends ReportListState {
  final List<Report> reports;
  ReportListLoaded(this.reports);
}

class ReportListError extends ReportListState {
  final String message;
  ReportListError(this.message);
}