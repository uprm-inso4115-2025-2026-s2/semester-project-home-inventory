import 'package:intl/intl.dart';

String historyDateLabel(DateTime date, {DateTime? reference}) {
  final now = reference ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);

  if (day == today) {
    return 'Today';
  }
  if (day == today.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  }
  return DateFormat('MMMM d, yyyy').format(date);
}
