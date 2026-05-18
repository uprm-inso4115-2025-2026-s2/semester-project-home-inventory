import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';
import 'package:src/features/core_inventory/presentation/widgets/stock_item_edit_mode_tile.dart';
import 'package:src/features/core_inventory/presentation/widgets/stock_item_tile.dart';

class ProductStockPage extends StatefulWidget {
  const ProductStockPage({super.key});

  @override
  State<ProductStockPage> createState() => _ProductStockPageState();
}

class _ProductStockPageState extends State<ProductStockPage> {
  static const _kGreen = Color(0xFF2B4A2A);

  bool _isEditMode = false;
  String? _activeFilter;
  bool _sortAscending = true;
  late List<StockEntity> _stocks;
  late ProductEntity _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() {
    final productId =
        int.tryParse(
          GoRouterState.of(context).pathParameters['productId'] ?? '',
        ) ??
        0;
    final inventory = buildSampleInventory();
    _product = inventory.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => inventory.stock.keys.first,
    );
    _stocks = List<StockEntity>.from(inventory.stock[_product] ?? []);
  }

  List<StockEntity> get _displayedStocks {
    if (_activeFilter != 'expiration') return _stocks;
    final sorted = List<StockEntity>.from(_stocks);
    sorted.sort((a, b) {
      final aDate = a.expirationDate;
      final bDate = b.expirationDate;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return _sortAscending ? 1 : -1;
      if (bDate == null) return _sortAscending ? -1 : 1;
      return _sortAscending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });
    return sorted;
  }

  int get _totalQuantity => _stocks.fold(0, (sum, s) => sum + s.quantity);

  DateTime? get _earliestExpiration {
    DateTime? earliest;
    for (final s in _stocks) {
      if (s.expirationDate == null) continue;
      if (earliest == null || s.expirationDate!.isBefore(earliest)) {
        earliest = s.expirationDate;
      }
    }
    return earliest;
  }

  // ── actions ────────────────────────────────────────────────────────────────

  void _enterEditMode() => setState(() => _isEditMode = true);
  void _cancelEditMode() => setState(() => _isEditMode = false);
  void _doneEditMode() => setState(() => _isEditMode = false);

  void _toggleSortDirection() =>
      setState(() => _sortAscending = !_sortAscending);

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
          ListTile(
            title: const Text(
              'Expiration Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() => _activeFilter = 'expiration');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(
              'Clear Filters',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() => _activeFilter = null);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _showViewMoreModal(StockEntity stock) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _ViewMoreDialog(
        stock: stock,
        onEdit: () {
          Navigator.of(ctx).pop();
          _showEditModal(stock);
        },
      ),
    );
  }

  void _showEditModal(StockEntity stock) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditStockDialog(
        stock: stock,
        onDone: (_, __) => Navigator.of(ctx).pop(),
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  void _showRemoveConfirmation(StockEntity stock) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Do you want to delete\nItem ID:${stock.id} ?\nPlease Confirm',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('NO'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => _stocks.removeWhere((s) => s.id == stock.id));
              Navigator.of(ctx).pop();
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }

  void _showAddModal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add stock entry — coming soon')),
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filterLabel = _activeFilter == 'expiration'
        ? 'Filter by: Expiration'
        : 'Filter by';

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductHeaderCard(
                product: _product,
                totalQuantity: _totalQuantity,
                earliestExpiration: _earliestExpiration,
              ),
              SizedBox(height: 2.h),
              _buildControlsRow(filterLabel),
              SizedBox(height: 1.h),
              Expanded(child: _buildStockList()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _isEditMode
          ? TextButton(
              onPressed: _cancelEditMode,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
      title: const Text('Product Stock'),
      actions: [
        _isEditMode
            ? Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: TextButton(
                  onPressed: _doneEditMode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _kGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: TextButton(
                  onPressed: _enterEditMode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: _kGreen),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Edit',
                      style: const TextStyle(color: _kGreen),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildControlsRow(String filterLabel) {
    return Row(
      children: [
        const Text(
          'List:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Spacer(),
        _FilterButton(label: filterLabel, onTap: _showFilterSheet),
        if (_activeFilter != null) ...[
          SizedBox(width: 1.w),
          IconButton(
            onPressed: _toggleSortDirection,
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: _kGreen,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
        if (_isEditMode) ...[
          SizedBox(width: 1.w),
          IconButton(
            onPressed: _showAddModal,
            icon: const Icon(Icons.add, color: _kGreen),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }

  Widget _buildStockList() {
    final stocks = _displayedStocks;

    if (stocks.isEmpty) {
      return const Center(child: Text('No stock entries.'));
    }

    return ListView.separated(
      itemCount: stocks.length,
      separatorBuilder: (_, __) => SizedBox(height: 1.h),
      itemBuilder: (_, index) {
        final stock = stocks[index];
        if (_isEditMode) {
          return StockItemEditModeTile(
            stock: stock,
            onViewMore: () => _showViewMoreModal(stock),
            onEdit: () => _showEditModal(stock),
            onRemove: () => _showRemoveConfirmation(stock),
          );
        }
        return StockItemTile(
          stock: stock,
          onViewMore: () => _showViewMoreModal(stock),
          onEdit: () => _showEditModal(stock),
        );
      },
    );
  }
}

// ── Header card ────────────────────────────────────────────────────────────────

class _ProductHeaderCard extends StatelessWidget {
  const _ProductHeaderCard({
    required this.product,
    required this.totalQuantity,
    required this.earliestExpiration,
  });

  final ProductEntity product;
  final int totalQuantity;
  final DateTime? earliestExpiration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B4A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.white54, size: 32),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'quantity: $totalQuantity',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'earliest expiration date: ${_formatDate(earliestExpiration)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// ── Filter button ──────────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2B4A2A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}

// ── View More dialog ───────────────────────────────────────────────────────────

class _ViewMoreDialog extends StatelessWidget {
  const _ViewMoreDialog({required this.stock, required this.onEdit});

  final StockEntity stock;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  'ID: ${stock.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Note:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(stock.brand),
            ),
            const SizedBox(height: 12),
            const Text(
              'Edit Expiration Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_formatDate(stock.expirationDate)),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B4A2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// ── Edit Stock dialog ──────────────────────────────────────────────────────────

class _EditStockDialog extends StatefulWidget {
  const _EditStockDialog({
    required this.stock,
    required this.onDone,
    required this.onCancel,
  });

  final StockEntity stock;
  final void Function(String note, String expirationDate) onDone;
  final VoidCallback onCancel;

  @override
  State<_EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends State<_EditStockDialog> {
  late final TextEditingController _noteController;
  late final TextEditingController _expirationController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.stock.brand);
    _expirationController = TextEditingController(
      text: _formatDate(widget.stock.expirationDate),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _expirationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2B4A2A);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: green),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.stock.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Note:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                border: border,
                focusedBorder: border,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Edit Expiration Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _expirationController,
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                border: border,
                focusedBorder: border,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => widget.onDone(
                    _noteController.text,
                    _expirationController.text,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}