class BudgetModel {
  final int id;
  final String name;
  final double amount;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime createdAt;

  const BudgetModel({
    required this.id,
    required this.name,
    required this.amount,
    this.periodStart,
    this.periodEnd,
    required this.createdAt,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      periodStart: map['period_start'] != null
          ? DateTime.parse(map['period_start'] as String)
          : null,
      periodEnd: map['period_end'] != null
          ? DateTime.parse(map['period_end'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'period_start': periodStart?.toIso8601String(),
      'period_end': periodEnd?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}