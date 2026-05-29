import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/grocery_list/presentation/utils/history_date_label.dart';

void main() {
  final reference = DateTime(2025, 3, 12, 14, 30);

  test('labels today', () {
    expect(
      historyDateLabel(DateTime(2025, 3, 12, 9), reference: reference),
      'Today',
    );
  });

  test('labels yesterday', () {
    expect(
      historyDateLabel(DateTime(2025, 3, 11, 22), reference: reference),
      'Yesterday',
    );
  });

  test('labels older dates with full format', () {
    expect(
      historyDateLabel(DateTime(2025, 3, 10), reference: reference),
      'March 10, 2025',
    );
  });
}
