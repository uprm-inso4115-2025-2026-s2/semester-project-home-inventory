import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class StockItemTile extends StatelessWidget {
  const StockItemTile({
    super.key,
    required this.stock,
    required this.onViewMore,
    required this.onEdit,
  });

  final StockEntity stock;
  final VoidCallback onViewMore;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB8D4B8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImagePlaceholder(size: 14.w),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item ID: ${stock.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Note:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      stock.brand,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 20),
                onSelected: (value) {
                  if (value == 'view_more') onViewMore();
                  if (value == 'edit') onEdit();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'view_more', child: Text('View More')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                ],
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              SizedBox(width: 16.w),
              Text(
                'expiration date: ${_formatDate(stock.expirationDate)}',
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              _StatusDot(status: stock.status),
            ],
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Colors.white70, size: 28),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }

  Color get _color {
    switch (status) {
      case Status.FULL:
        return Colors.green;
      case Status.HALFWAY:
        return Colors.yellow;
      case Status.LOW:
        return Colors.orange;
      case Status.EMPTY:
        return Colors.red;
      case Status.EXPIRED:
        return Colors.purple;
      case Status.DAMAGED:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}