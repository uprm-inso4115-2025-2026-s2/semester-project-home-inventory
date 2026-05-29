import 'package:equatable/equatable.dart';
import 'package:src/features/grocery_list/domain/entities/custom_collection_item.dart';
import 'package:src/features/grocery_list/domain/entities/grocery_list_item.dart';

class GroceryListState extends Equatable {
  const GroceryListState({
    this.items = const [],
    this.customCollectionItems = const [],
  });

  final List<GroceryListItem> items;
  final List<CustomCollectionItem> customCollectionItems;

  bool get hasCustomCollection => customCollectionItems.isNotEmpty;

  GroceryListState copyWith({
    List<GroceryListItem>? items,
    List<CustomCollectionItem>? customCollectionItems,
  }) {
    return GroceryListState(
      items: items ?? this.items,
      customCollectionItems:
          customCollectionItems ?? this.customCollectionItems,
    );
  }

  @override
  List<Object?> get props => [items, customCollectionItems];
}
