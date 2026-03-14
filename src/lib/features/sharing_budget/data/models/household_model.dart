import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';

class HouseholdModel extends HouseholdEntity {
  const HouseholdModel({
    required super.id,
    required super.name,
    required super.ownerId,
  });

  factory HouseholdModel.fromEntity(HouseholdEntity entity) {
    return HouseholdModel(
      id: entity.id,
      name: entity.name,
      ownerId: entity.ownerId,
    );
  }

  HouseholdEntity toEntity() {
    return this as HouseholdEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_id': ownerId,
    };
  }

  factory HouseholdModel.fromJson(Map<String, dynamic> json) {
    return HouseholdModel(
      id: json['id'] as int,
      name: json['name'] as String,
      ownerId: json['owner_id'] as int,
    );
  }

  factory HouseholdModel.initial() {
    return const HouseholdModel(id: -1, name: '', ownerId: -1);
  }
}
