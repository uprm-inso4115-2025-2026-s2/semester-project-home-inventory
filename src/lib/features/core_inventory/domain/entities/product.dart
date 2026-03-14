import 'package:src/features/core_inventory/domain/entities/enums.dart';

class ProductEntity {
  final int id;
  final String name;
  final String description;
  final List<Tag> tags;
  final String? unit;
  final String? imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    this.tags = const [],
    this.unit,
    this.imageUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductEntity) return false;
    return id == other.id &&
        name == other.name &&
        description == other.description &&
        tags == other.tags &&
        unit == other.unit &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
