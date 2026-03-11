import '../entities/expiration_status.dart';


// determines expiration status of an item based on its expiration date
ExpirationStatus checkExpiration({
  required DateTime? expirationDate,
  int thresholdInDays = 7,
  DateTime? currentDate,
}){
  // use the provided date for testing, otherwise use the current date
  final now = currentDate ?? DateTime.now();

  // normalize today's date (remove time component)
  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  // items without an expiration date are considered OK
  if (expirationDate == null){
    return ExpirationStatus.ok;
  }

   // normalize expiration date to avoid time comparison issues
  final normalizedExpirationDate = DateTime(
    expirationDate.year,
    expirationDate.month,
    expirationDate.day,
  );

  // calculate the number of days until the item expires
  final daysUntilExpiration =
      normalizedExpirationDate.difference(today).inDays;

  // if expiration date is today or in the past, it's expired
  if (daysUntilExpiration <= 0){
    return ExpirationStatus.expired;
    // if the item expires within the threshold window, mark as near expiration
  } if (daysUntilExpiration <= thresholdInDays){
    return ExpirationStatus.nearExpiration;
    // otherwise, the item is still OK
  } return ExpirationStatus.ok;
}