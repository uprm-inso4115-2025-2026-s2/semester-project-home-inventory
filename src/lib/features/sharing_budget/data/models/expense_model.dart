class ExpenseModel {
  final int id;
  final int householdId;
  final int? userId;
  final double amount;
  final String? category;
  final String? description;
  final DateTime incurredOn;
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.householdId,
    this.userId,
    required this.amount,
    this.category,
    this.description,
    required this.incurredOn,
    required this.createdAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
      userId: map['user_id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String?,
      description: map['description'] as String?,
      incurredOn: DateTime.parse(map['incurred_on'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'household_id': householdId,
      'user_id': userId,
      'amount': amount,
      'category': category,
      'description': description,
      'incurred_on': incurredOn.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}