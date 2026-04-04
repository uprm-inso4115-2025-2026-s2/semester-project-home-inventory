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
    return HouseholdEntity(
      id: id,
      name: name,
      ownerId: ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'owner_id': ownerId,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory HouseholdModel.fromMap(Map<String, dynamic> map) {
    return HouseholdModel(
      id: map['id'] as int,
      name: map['name'] as String,
      ownerId: map['owner_id'] as int,
    );
  }

  factory HouseholdModel.fromJson(Map<String, dynamic> json) =>
      HouseholdModel.fromMap(json);

  factory HouseholdModel.initial() {
    return const HouseholdModel(id: -1, name: '', ownerId: -1);
  }
}