import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/config/router.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.title,
    this.isHistory = false,
    this.isCustom = false,
    this.itemId,
    this.quantity = 0,
    this.imageUrl,
    this.onRemove,
  });

  final String title;
  final bool isHistory;
  final bool isCustom;
  final String? itemId;
  final int quantity;
  final String? imageUrl;
  final VoidCallback? onRemove;

  bool get _usesGroceryListState => itemId != null && !isHistory && !isCustom;
  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  GroceryListCubit get _cubit => sl<GroceryListCubit>();

  String get _initial {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isCustom) {
          AppRouter.goTo(context, "edit_item");
          return;
        }
        if (_usesGroceryListState) {
          _showActionSheet(context, title);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primary,
            border: Border.all(color: secondary.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              _buildLeading(),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (_hasImage) {
      final source = imageUrl!;
      final isNetwork = source.startsWith('http');
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isNetwork
            ? Image.network(
                source,
                width: 14.w,
                height: 14.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitialAvatar(),
              )
            : Image.file(
                File(source),
                width: 14.w,
                height: 14.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitialAvatar(),
              ),
      );
    }
    return _buildInitialAvatar();
  }

  Widget _buildInitialAvatar() {
    return CircleAvatar(
      radius: 6.w,
      backgroundColor: secondary,
      child: Text(
        _initial,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isHistory && !isCustom)
          GestureDetector(
            onTap: _decrement,
            child: Icon(
              CupertinoIcons.minus_circle_fill,
              size: 25.sp,
              color: secondary,
            ),
          ),
        if (!isCustom)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
          ),
        if (isCustom)
          GestureDetector(
            onTap: () => _showDeleteDialog(context),
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              size: 25.sp,
              color: secondary,
            ),
          ),
        if (!isHistory && !isCustom)
          GestureDetector(
            onTap: _increment,
            child: Icon(
              CupertinoIcons.plus_circle_fill,
              size: 25.sp,
              color: secondary,
            ),
          ),
      ],
    );
  }

  void _increment() {
    if (_usesGroceryListState) {
      _cubit.incrementQuantity(itemId!);
    }
  }

  void _decrement() {
    if (_usesGroceryListState) {
      _cubit.decrementQuantity(itemId!);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Remove item'),
        content: Text('Remove "$title" from custom items?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onRemove?.call();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context, String itemTitle) {
    final groceryItemId = itemId;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(
          itemTitle,
          style: TextStyle(
            fontSize: 13.sp,
            color: CupertinoColors.inactiveGray,
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              sheetContext.pop();
              // TODO: Mark as completed
            },
            child: const Text('Mark as completed'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              if (groceryItemId != null) {
                _cubit.removeItem(groceryItemId);
              }
              sheetContext.pop();
            },
            child: const Text('Remove from list'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
