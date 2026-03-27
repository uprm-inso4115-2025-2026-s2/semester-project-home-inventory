import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/report_metrics.dart';
import '../../domain/repositories/report_repositories.dart';

part 'report_list_state.dart';

class ReportListCubit extends Cubit<ReportListState> {
  final ReportRepository repository;
  Timer? _debounce;

  ReportListCubit(this.repository) : super(ReportListInitial());

  Future<void> loadReports() async {
    emit(ReportListLoading());
    try {
      final reports = await repository.fetchReports();
      emit(ReportListLoaded(reports));
    } catch (e) {
      emit(ReportListError(e.toString()));
    }
  }

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(ReportListLoading());
      try {
        final results = await repository.searchReports(query);
        emit(ReportListLoaded(results));
      } catch (e) {
        emit(ReportListError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}