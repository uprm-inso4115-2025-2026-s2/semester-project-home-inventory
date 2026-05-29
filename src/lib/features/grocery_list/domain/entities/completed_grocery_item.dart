import 'package:equatable/equatable.dart';

class CompletedGroceryItem extends Equatable {
  const CompletedGroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.completedAt,
  });

  final String id;
  final String name;
  final int quantity;
  final DateTime completedAt;

  @override
  List<Object?> get props => [id, name, quantity, completedAt];
}
