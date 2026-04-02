import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/cubits/edit_item_state.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';

class EditItemCubit extends Cubit<EditItemState> {
  EditItemCubit(int itemId) : super(_buildInitialState(itemId));

  static EditItemState _buildInitialState(int itemId) {
    final inventory = buildSampleInventory();
    final pair = findProductAndStockByStockId(inventory, itemId);

    if (pair != null) {
      return EditItemState(product: pair.key, stock: pair.value);
    }

    return const EditItemState(
      product: ProductEntity(id: 0, name: 'Item', description: 'Item details'),
      stock: StockEntity(
        id: 0,
        brand: 'Generic',
        quantity: 1,
        status: Status.UNKNOWN,
      ),
    );
  }
}
