import 'package:equatable/equatable.dart';
import 'package:src/features/grocery_list/domain/entities/completed_grocery_item.dart';
import 'package:src/features/grocery_list/domain/entities/custom_collection_item.dart';
import 'package:src/features/grocery_list/domain/entities/grocery_list_item.dart';

class GroceryListState extends Equatable {
  const GroceryListState({
    this.items = const [],
    this.customCollectionItems = const [],
    this.completedItems = const [],
  });

  final List<GroceryListItem> items;
  final List<CustomCollectionItem> customCollectionItems;
  final List<CompletedGroceryItem> completedItems;

  bool get hasCustomCollection => customCollectionItems.isNotEmpty;

  GroceryListState copyWith({
    List<GroceryListItem>? items,
    List<CustomCollectionItem>? customCollectionItems,
    List<CompletedGroceryItem>? completedItems,
  }) {
    return GroceryListState(
      items: items ?? this.items,
      customCollectionItems:
          customCollectionItems ?? this.customCollectionItems,
      completedItems: completedItems ?? this.completedItems,
    );
  }

  @override
  List<Object?> get props => [items, customCollectionItems, completedItems];
}
