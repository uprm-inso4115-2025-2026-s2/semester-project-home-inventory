import 'package:equatable/equatable.dart';

class GroceryListItem extends Equatable {
  const GroceryListItem({
    required this.id,
    required this.name,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final int quantity;

  GroceryListItem copyWith({String? id, String? name, int? quantity}) {
    return GroceryListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity];
}
