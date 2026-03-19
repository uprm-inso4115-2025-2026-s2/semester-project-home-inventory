class HouseholdSummaryModel {
  final int id;
  final int householdId;
  final String? month;
  final double totalSpent;
  final double budgetLimit;
  final DateTime updatedAt;

  const HouseholdSummaryModel({
    required this.id,
    required this.householdId,
    this.month,
    required this.totalSpent,
    required this.budgetLimit,
    required this.updatedAt,
  });

  factory HouseholdSummaryModel.fromMap(Map<String, dynamic> map) {
    return HouseholdSummaryModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
      month: map['month'] as String?,
      totalSpent: (map['total_spent'] as num).toDouble(),
      budgetLimit: (map['budget_limit'] as num).toDouble(),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'household_id': householdId,
      'month': month,
      'total_spent': totalSpent,
      'budget_limit': budgetLimit,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}