import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/alerts_restock/domain/entities/expiration_status.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_expiration.dart';

void main(){
  // fixed date used to simulate "today" during tests
  final baseDate = DateTime(2026, 3, 10);

  // item without exp date should be OK
  test('returns ok when expiration date is null', () {
    final result = checkExpiration(
      expirationDate: null,
      currentDate: baseDate,
    );

    expect(result, ExpirationStatus.ok);
  });

  // past exp dates should be marked as expired
  test('returns expired when expiration date is in the past', (){
    final result = checkExpiration(
      expirationDate: DateTime(2026, 3, 9),
      currentDate: baseDate,
    );

    expect(result, ExpirationStatus.expired);
  });

  // exp date equal to today should also be expired
  test('returns expired when expiration date is today', (){
    final result = checkExpiration(
      expirationDate: DateTime(2026, 3, 10),
      currentDate: baseDate,
    );

    expect(result, ExpirationStatus.expired);
  });

  // dates within the threshold window should be near expiration
  test('returns nearExpiration when date is within threshold', (){
    final result = checkExpiration(
      expirationDate: DateTime(2026, 3, 15),
      thresholdInDays: 5,
      currentDate: baseDate,
    );

    expect(result, ExpirationStatus.nearExpiration);
  });

  // dates beyond the threshold should be OK
  test('returns ok when date is outside threshold', (){
    final result = checkExpiration(
      expirationDate: DateTime(2026, 3, 20),
      thresholdInDays: 5,
      currentDate: baseDate,
    );

    expect(result, ExpirationStatus.ok);
  });
}