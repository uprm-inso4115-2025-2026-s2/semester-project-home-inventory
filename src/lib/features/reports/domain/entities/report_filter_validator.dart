import '../entities/report_filters.dart';

/// Severity level of a conflict.
enum ConflictSeverity { error, warning }

/// Represents a single validation conflict.
class Conflict {
  final String type;
  final ConflictSeverity severity;
  final String message;
  final String suggestion;
  final List<String> affectedFields;

  Conflict({
    required this.type,
    required this.severity,
    required this.message,
    required this.suggestion,
    this.affectedFields = const [],
  });
}

/// Result of a validation run.
class ValidationResult {
  final bool isValid;
  final List<Conflict> conflicts;

  ValidationResult({required this.isValid, required this.conflicts});

  bool get hasErrors => conflicts.any((c) => c.severity == ConflictSeverity.error);
  bool get hasWarnings => conflicts.any((c) => c.severity == ConflictSeverity.warning);
}

/// Utility that detects conflicting filter combinations.
class ReportFilterValidator {
  static const int maxDateRangeDays = 90;

  /// Validate the given filters.
  /// [totalAvailableItems] should be the total count of items that match the filters.
  Future<ValidationResult> validate(
    ReportFilters filters, {
    required int totalAvailableItems,
  }) async {
    final conflicts = <Conflict>[];

    // ---------- Temporal conflicts ----------
    if (filters.endDate.isBefore(filters.startDate)) {
      conflicts.add(Conflict(
        type: 'end_before_start',
        severity: ConflictSeverity.error,
        message: 'End date cannot be before start date.',
        suggestion: 'Choose an end date that is after the start date.',
        affectedFields: ['endDate'],
      ));
    }

    final daysDiff = filters.endDate.difference(filters.startDate).inDays;
    if (daysDiff > maxDateRangeDays) {
      conflicts.add(Conflict(
        type: 'range_too_long',
        severity: ConflictSeverity.error,
        message: 'Date range exceeds $maxDateRangeDays days.',
        suggestion: 'Narrow your date range to $maxDateRangeDays days or less.',
        affectedFields: ['startDate', 'endDate'],
      ));
    }

    final today = DateTime.now();
    if (filters.endDate.isAfter(today)) {
      conflicts.add(Conflict(
        type: 'future_date',
        severity: ConflictSeverity.warning,
        message: 'End date is in the future. No data beyond today exists.',
        suggestion: 'Use a date up to today for accurate results.',
        affectedFields: ['endDate'],
      ));
    }

    // ---------- Data availability ----------
    if (totalAvailableItems == 0) {
      conflicts.add(Conflict(
        type: 'no_data',
        severity: ConflictSeverity.warning,
        message: 'No items match your current filters.',
        suggestion: 'Widen the date range or change search term.',
        affectedFields: ['startDate', 'endDate', 'searchQuery'],
      ));
    }

    // ---------- Performance conflicts ----------
    if (filters.searchQuery.length == 1) {
      conflicts.add(Conflict(
        type: 'broad_search',
        severity: ConflictSeverity.warning,
        message: 'Single‑character search may return too many results.',
        suggestion: 'Use at least 2‑3 characters for better filtering.',
        affectedFields: ['searchQuery'],
      ));
    }

    return ValidationResult(
      isValid: conflicts.every((c) => c.severity != ConflictSeverity.error),
      conflicts: conflicts,
    );
  }
}