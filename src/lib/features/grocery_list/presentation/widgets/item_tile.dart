import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/features/grocery_list/data/constants.dart';

class ItemTile extends StatefulWidget {
  const ItemTile({
    super.key,
    required this.title,
    this.isHistory = false,
    this.isCustom = false,
  });
  final String title;
  final bool isHistory;
  final bool isCustom;

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.isCustom
          ? AppRouter.goTo(context, "edit_item")
          : showActionSheet(context, widget.title),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          width: double.infinity,
          height: 13.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 8.h,
                    decoration: BoxDecoration(color: secondary),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isHistory && !widget.isCustom)
                    GestureDetector(
                      onTap: () {
                        decrementQuantity();
                      },
                      child: Icon(
                        CupertinoIcons.minus_circle_fill,
                        size: 25.sp,
                        color: secondary,
                      ),
                    ),
                  if (!widget.isCustom)
                    SizedBox(
                      width: 13.w,
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  if (widget.isCustom)
                    GestureDetector(
                      onTap: () => _showDeleteDialog(context),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 25.sp,
                        color: secondary,
                      ),
                    ),
                  if (widget.isHistory || widget.isCustom)
                    SizedBox(width: 9.5.w),
                  if (!widget.isHistory && !widget.isCustom)
                    GestureDetector(
                      onTap: () {
                        incrementQuantity();
                      },
                      child: Icon(
                        CupertinoIcons.plus_circle_fill,
                        size: 25.sp,
                        color: secondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Remove item'),
        content: Text('Remove "${widget.title}" from custom items?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: delete item when backend is ready
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void showActionSheet(BuildContext context, String itemTitle) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
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
              context.pop();
              // TODO: Edit item
            },
            child: const Text('Mark as completed'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              context.pop();
              // TODO: Delete item
            },
            child: const Text('Remove from list'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
