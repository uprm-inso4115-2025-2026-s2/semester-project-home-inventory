class HouseholdEntity {
  final int id;
  final String name;
  final int ownerId;

  const HouseholdEntity({
    required this.id,
    required this.name,
    required this.ownerId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HouseholdEntity) return false;
    return id == other.id && name == other.name && ownerId == other.ownerId;
  }

  @override
  int get hashCode => id.hashCode;
}
