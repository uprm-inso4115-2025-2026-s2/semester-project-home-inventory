import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    super.tags = const [],
    super.unit,
    super.imageUrl,
  });

  factory ProductModel.fromEntity(ProductEntity entity) {
    return entity as ProductModel;
  }

  ProductEntity toEntity() {
    return this as ProductEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags.map((tag) => tag.name).toList(),
      'unit': unit,
      'imageUrl': imageUrl,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((tag) => Tag.values.firstWhere((t) => t.name == tag))
              .toList() ??
          [],
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  factory ProductModel.initial() {
    return ProductModel(
      id: -1,
      name: '',
      description: '',
      tags: [],
      unit: '',
      imageUrl: '',
    );
  }
}
