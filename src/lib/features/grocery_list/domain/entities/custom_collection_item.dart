import 'package:equatable/equatable.dart';

class CustomCollectionItem extends Equatable {
  const CustomCollectionItem({
    required this.id,
    required this.name,
    this.imagePath,
  });

  final String id;
  final String name;
  final String? imagePath;

  CustomCollectionItem copyWith({
    String? id,
    String? name,
    String? imagePath,
  }) {
    return CustomCollectionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath];
}
