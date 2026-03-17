class HouseholdModel {
  final int id;
  final String name;
  final DateTime createdAt;

  const HouseholdModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory HouseholdModel.fromMap(Map<String, dynamic> map) {
    return HouseholdModel(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}