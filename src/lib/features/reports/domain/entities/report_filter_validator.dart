// ============================================================================
// REPORT FILTER CONFLICT DETECTION UTILITY
// ============================================================================
// 
// RESEARCH DOCUMENTATION – TYPES OF FILTER CONFLICTS
// ============================================================================
// 
// This utility detects and prevents conflicting filter combinations in report 
// screens before they are sent to Supabase. The following conflict types have 
// been identified and implemented:
// 
// 1. TEMPORAL CONFLICTS (Time‑based issues)
//    ------------------------------------------------------------
//    | Conflict              | Severity | Detection               |
//    |-----------------------|----------|-------------------------|
//    | End before start      | Error    | compare DateTime objects|
//    | Range > 90 days       | Error    | days difference         |
//    | Future end date       | Warning  | compare with today      |
//    ------------------------------------------------------------
//    Example: startDate = 2026-03-15, endDate = 2026-03-09
//    User feedback: "End date cannot be before start date."
// 
// 2. DATA AVAILABILITY CONFLICTS
//    ------------------------------------------------------------
//    | Conflict              | Severity | Detection               |
//    |-----------------------|----------|-------------------------|
//    | No matching items     | Warning  | totalAvailableItems == 0|
//    ------------------------------------------------------------
//    Example: Filters return zero results (e.g., date range with no data)
//    User feedback: "No items match your current filters. Widen the date range..."
// 
// 3. PERFORMANCE CONFLICTS
//    ------------------------------------------------------------
//    | Conflict              | Severity | Detection               |
//    |-----------------------|----------|-------------------------|
//    | Single‑char search    | Warning  | searchQuery.length == 1 |
//    ------------------------------------------------------------
//    Example: searchQuery = "a" (too broad)
//    User feedback: "Single‑character search may return too many results..."
// 
// Note: Additional conflict types (too many categories, large date range,
//       unauthorized access, etc.) can be added as needed by extending the
//       validate() method with more checks.
// 
// ============================================================================
// USAGE EXAMPLE
// ============================================================================
// 
// ```dart
// final validator = ReportFilterValidator();
// final result = await validator.validate(
//   filters,
//   totalAvailableItems: 42,
// );
// if (result.hasErrors) {
//   // Disable report generation, show error messages
// } else if (result.hasWarnings) {
//   // Show warning dialog with option to proceed
// }
// ```
// 
// ============================================================================

import '../entities/report_filters.dart';

/// Severity level of a conflict.
/// - [error]: Prevents report generation (must be fixed).
/// - [warning]: Allows generation after user confirmation.
enum ConflictSeverity { error, warning }

/// Represents a single validation conflict detected by [ReportFilterValidator].
/// Contains the conflict type, severity, user‑friendly message, suggested fix,
/// and which form fields are affected.
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
/// Provides the overall validity and lists all detected conflicts.
class ValidationResult {
  final bool isValid;
  final List<Conflict> conflicts;

  ValidationResult({required this.isValid, required this.conflicts});

  /// True if at least one error (blocking) conflict exists.
  bool get hasErrors => conflicts.any((c) => c.severity == ConflictSeverity.error);
  
  /// True if at least one warning (non‑blocking) conflict exists.
  bool get hasWarnings => conflicts.any((c) => c.severity == ConflictSeverity.warning);
}

/// Utility that detects conflicting filter combinations in real time.
/// 
/// This class implements the research findings documented above. It is designed
/// to be called on every filter change (with debouncing) and returns a
/// [ValidationResult] that can be used to show inline error messages,
/// disable the "Generate Report" button, or ask for confirmation on warnings.
class ReportFilterValidator {
  static const int maxDateRangeDays = 90;

  /// Validate the given filters.
  ///
  /// Parameters:
  /// - [filters]: The current report filters (date range, search query, etc.)
  /// - [totalAvailableItems]: Total count of items that match the current
  ///   filters (from your data source). Used to detect "no data" conflicts.
  ///
  /// Returns a [ValidationResult] with:
  /// - `isValid` – true if there are no errors (warnings are allowed)
  /// - `conflicts` – list of all detected issues with severity, messages, etc.
  ///
  /// The method performs the following checks in order:
  /// 1. Temporal: end before start, range too long, future end date
  /// 2. Data availability: no items match filters
  /// 3. Performance: single‑character search
  Future<ValidationResult> validate(
    ReportFilters filters, {
    required int totalAvailableItems,
  }) async {
    final conflicts = <Conflict>[];

    // ---------- 1. TEMPORAL CONFLICTS ----------
    // Check: End date before start date → Error
    if (filters.endDate.isBefore(filters.startDate)) {
      conflicts.add(Conflict(
        type: 'end_before_start',
        severity: ConflictSeverity.error,
        message: 'End date cannot be before start date.',
        suggestion: 'Choose an end date that is after the start date.',
        affectedFields: ['endDate'],
      ));
    }

    // Check: Date range exceeds max allowed days → Error
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

    // Check: Future end date → Warning (data may be incomplete)
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

    // ---------- 2. DATA AVAILABILITY CONFLICT ----------
    // Check: No items match the current filters → Warning
    if (totalAvailableItems == 0) {
      conflicts.add(Conflict(
        type: 'no_data',
        severity: ConflictSeverity.warning,
        message: 'No items match your current filters.',
        suggestion: 'Widen the date range or change search term.',
        affectedFields: ['startDate', 'endDate', 'searchQuery'],
      ));
    }

    // ---------- 3. PERFORMANCE CONFLICT ----------
    // Check: Single‑character search query → Warning (too broad)
    if (filters.searchQuery.length == 1) {
      conflicts.add(Conflict(
        type: 'broad_search',
        severity: ConflictSeverity.warning,
        message: 'Single‑character search may return too many results.',
        suggestion: 'Use at least 2‑3 characters for better filtering.',
        affectedFields: ['searchQuery'],
      ));
    }

    // Final result: valid only if there are no error‑level conflicts
    return ValidationResult(
      isValid: conflicts.every((c) => c.severity != ConflictSeverity.error),
      conflicts: conflicts,
    );
  }
}