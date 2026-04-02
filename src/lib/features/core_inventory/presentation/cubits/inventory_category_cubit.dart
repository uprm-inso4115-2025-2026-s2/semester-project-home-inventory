import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_category_state.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';

class InventoryCategoryCubit extends Cubit<InventoryCategoryState> {
  InventoryCategoryCubit(String categoryId)
    : super(_buildInitialState(categoryId));

  static InventoryCategoryState _buildInitialState(String categoryId) {
    final inventory = buildSampleInventory();

    return InventoryCategoryState(
      categoryId: categoryId,
      title: inventoryCategoryTitle(categoryId),
      inventory: inventory,
      products: filterProductsForCategory(inventory, categoryId),
    );
  }
}
