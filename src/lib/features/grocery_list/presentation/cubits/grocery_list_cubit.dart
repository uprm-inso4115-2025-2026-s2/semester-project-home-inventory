import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/grocery_list/domain/entities/custom_collection_item.dart';
import 'package:src/features/grocery_list/domain/entities/grocery_list_item.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';

class GroceryListCubit extends Cubit<GroceryListState> {
  GroceryListCubit() : super(const GroceryListState());

  bool addItem(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    final existingIndex = state.items.indexWhere(
      (item) => item.name.toLowerCase() == trimmed.toLowerCase(),
    );

    if (existingIndex >= 0) {
      final updatedItems = [...state.items];
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
      emit(state.copyWith(items: updatedItems));
      return true;
    }

    final item = GroceryListItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmed,
    );
    emit(state.copyWith(items: [...state.items, item]));
    return true;
  }

  bool addCustomCollectionItem(String name, {String? imagePath}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    final isDuplicate = state.customCollectionItems.any(
      (item) => item.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (isDuplicate) {
      return false;
    }

    final item = CustomCollectionItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmed,
      imagePath: imagePath,
    );
    emit(
      state.copyWith(
        customCollectionItems: [...state.customCollectionItems, item],
      ),
    );
    return true;
  }

  void removeCustomCollectionItem(String id) {
    final updated = state.customCollectionItems
        .where((item) => item.id != id)
        .toList();
    emit(state.copyWith(customCollectionItems: updated));
  }

  void incrementQuantity(String id) {
    _updateQuantity(id, 1);
  }

  void decrementQuantity(String id) {
    final item = state.items.firstWhere((entry) => entry.id == id);
    if (item.quantity <= 1) {
      removeItem(id);
      return;
    }
    _updateQuantity(id, -1);
  }

  void removeItem(String id) {
    emit(
      state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
      ),
    );
  }

  void _updateQuantity(String id, int delta) {
    final updatedItems = state.items.map((item) {
      if (item.id != id) {
        return item;
      }
      return item.copyWith(quantity: item.quantity + delta);
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }
}
