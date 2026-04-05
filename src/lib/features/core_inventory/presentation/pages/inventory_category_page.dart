import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';

class InventoryCategoryPage extends StatelessWidget {
  const InventoryCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId =
        GoRouterState.of(context).pathParameters['categoryId'] ?? 'in_stock';
    final inventory = buildSampleInventory();
    final title = inventoryCategoryTitle(categoryId);
    final products = filterProductsForCategory(inventory, categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 3.w,
                runSpacing: 1.h,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push('/inventory/category/$categoryId/labels');
                    },
                    child: const Text('Item Label Key'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/inventory/category/$categoryId/add');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final stocks =
                        inventory.stock[product] ?? const <StockEntity>[];
                    return _ItemCard(
                      product: product,
                      stocks: stocks,
                      onEdit: stocks.isEmpty
                          ? null
                          : () {
                              context.push(
                                '/inventory/category/$categoryId/edit/${stocks.first.id}',
                              );
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.product,
    required this.stocks,
    required this.onEdit,
  });

  final ProductEntity product;
  final List<StockEntity> stocks;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _totalQuantity(stocks);
    final earliestExpirationDate = _earliestExpirationDate(stocks);
    final displayStatus = _displayStatus(stocks);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.h),
            Text('Quantity: $totalQuantity'),
            Text(
              'Earliest Expiration Date: ${_formatDate(earliestExpirationDate)}',
            ),
            Text('Status: ${_statusLabel(displayStatus)}'),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _totalQuantity(List<StockEntity> stocks) {
    return stocks.fold(0, (sum, stock) => sum + stock.quantity);
  }

  DateTime? _earliestExpirationDate(List<StockEntity> stocks) {
    DateTime? earliest;

    for (final stock in stocks) {
      final expirationDate = stock.expirationDate;
      if (expirationDate == null) continue;

      if (earliest == null || expirationDate.isBefore(earliest)) {
        earliest = expirationDate;
      }
    }

    return earliest;
  }

  Status _displayStatus(List<StockEntity> stocks) {
    if (stocks.any((stock) => stock.status == Status.EMPTY)) {
      return Status.EMPTY;
    } else if (stocks.any((stock) => stock.status == Status.LOW)) {
      return Status.LOW;
    } else if (stocks.any((stock) => stock.status == Status.EXPIRED)) {
      return Status.EXPIRED;
    } else if (stocks.any((stock) => stock.status == Status.DAMAGED)) {
      return Status.DAMAGED;
    } else if (stocks.any((stock) => stock.status == Status.HALFWAY)) {
      return Status.HALFWAY;
    } else if (stocks.any((stock) => stock.status == Status.FULL)) {
      return Status.FULL;
    } else {
      return Status.UNKNOWN;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _statusLabel(Status status) {
    switch (status) {
      case Status.FULL:
        return 'Full';
      case Status.HALFWAY:
        return 'Halfway';
      case Status.LOW:
        return 'Low';
      case Status.EMPTY:
        return 'Empty';
      case Status.EXPIRED:
        return 'Expired';
      case Status.DAMAGED:
        return 'Damaged';
      default:
        return 'Unknown';
    }
  }
}
