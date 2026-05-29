import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/reports/domain/entities/report_filter_validator.dart';
import 'package:src/features/reports/domain/entities/report_filters.dart';

void main() {
  group('ReportFilterValidator', () {
    late ReportFilterValidator validator;

    setUp(() {
      validator = ReportFilterValidator();
    });

    test('returns an error when end date is before start date', () async {
      final result = await validator.validate(
        ReportFilters(
          startDate: DateTime(2026, 5, 10),
          endDate: DateTime(2026, 5, 1),
          page: 0,
          searchQuery: '',
        ),
        totalAvailableItems: 5,
      );

      expect(result.isValid, isFalse);
      expect(result.hasErrors, isTrue);
      expect(result.hasWarnings, isFalse);
      expect(result.conflicts, hasLength(1));
      expect(result.conflicts.single.type, 'end_before_start');
      expect(result.conflicts.single.severity, ConflictSeverity.error);
      expect(result.conflicts.single.affectedFields, ['endDate']);
    });

    test('returns an error when date range is longer than 90 days', () async {
      final result = await validator.validate(
        ReportFilters(
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 4, 5),
          page: 0,
          searchQuery: '',
        ),
        totalAvailableItems: 5,
      );

      expect(result.isValid, isFalse);
      expect(result.hasErrors, isTrue);
      expect(result.conflicts, hasLength(1));
      expect(result.conflicts.single.type, 'range_too_long');
      expect(result.conflicts.single.severity, ConflictSeverity.error);
      expect(result.conflicts.single.affectedFields, ['startDate', 'endDate']);
    });

    test(
      'allows warning-only conflicts without invalidating filters',
      () async {
        final result = await validator.validate(
          ReportFilters(
            startDate: DateTime.now().subtract(const Duration(days: 2)),
            endDate: DateTime.now().add(const Duration(days: 1)),
            page: 0,
            searchQuery: 'a',
          ),
          totalAvailableItems: 0,
        );

        expect(result.isValid, isTrue);
        expect(result.hasErrors, isFalse);
        expect(result.hasWarnings, isTrue);
        expect(
          result.conflicts.map((conflict) => conflict.type),
          containsAll(['future_date', 'no_data', 'broad_search']),
        );
        expect(
          result.conflicts.map((conflict) => conflict.severity),
          everyElement(ConflictSeverity.warning),
        );
      },
    );

    test(
      'returns no conflicts for a valid filter set with matching data',
      () async {
        final result = await validator.validate(
          ReportFilters(
            startDate: DateTime.now().subtract(const Duration(days: 10)),
            endDate: DateTime.now().subtract(const Duration(days: 1)),
            page: 0,
            searchQuery: 'milk',
          ),
          totalAvailableItems: 3,
        );

        expect(result.isValid, isTrue);
        expect(result.hasErrors, isFalse);
        expect(result.hasWarnings, isFalse);
        expect(result.conflicts, isEmpty);
      },
    );
  });
}
