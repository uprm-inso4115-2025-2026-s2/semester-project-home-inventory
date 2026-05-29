import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/reports/domain/entities/report_filter_validator.dart';
import 'package:src/features/reports/domain/entities/report_filters.dart';

void main() {
  group('ReportFilterValidator load-style validation', () {
    test(
      'keeps valid filters conflict-free across repeated requests',
      () async {
        final validator = ReportFilterValidator();
        final results = <ValidationResult>[];

        for (var index = 0; index < 500; index++) {
          final startDate = DateTime.now().subtract(
            Duration(days: 30 + (index % 10)),
          );
          final endDate = DateTime.now().subtract(
            Duration(days: 1 + (index % 5)),
          );

          results.add(
            await validator.validate(
              ReportFilters(
                startDate: startDate,
                endDate: endDate,
                page: index % 2,
                searchQuery: 'milk',
              ),
              totalAvailableItems: 10,
            ),
          );
        }

        expect(results, hasLength(500));
        expect(results.every((result) => result.isValid), isTrue);
        expect(results.every((result) => result.hasErrors), isFalse);
        expect(results.every((result) => result.hasWarnings), isFalse);
        expect(results.every((result) => result.conflicts.isEmpty), isTrue);
      },
    );
  });
}
