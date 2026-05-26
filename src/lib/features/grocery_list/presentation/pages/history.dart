import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/domain/entities/completed_grocery_item.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';
import 'package:src/features/grocery_list/presentation/utils/history_date_label.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';
import 'package:src/core/presentation/widgets/top.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Top(
              color: Colors.black,
              leftButton: () => context.pop(),
              title: "History",
              iconColor: primary,
            ),
            Expanded(
              child: BlocBuilder<GroceryListCubit, GroceryListState>(
                builder: (context, state) => _historyList(state.completedItems),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyList(List<CompletedGroceryItem> completedItems) {
    if (completedItems.isEmpty) {
      return Center(
        child: Text(
          'No completed items yet.\nMark items as completed from your grocery list.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
        ),
      );
    }

    final grouped = _groupByDate(completedItems);

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        for (final entry in grouped.entries) ...[
          _dateHeader(entry.key),
          for (final item in entry.value)
            ItemTile(
              title: item.name,
              quantity: item.quantity,
              isHistory: true,
            ),
        ],
      ],
    );
  }

  Map<String, List<CompletedGroceryItem>> _groupByDate(
    List<CompletedGroceryItem> items,
  ) {
    final grouped = <String, List<CompletedGroceryItem>>{};
    for (final item in items) {
      final label = historyDateLabel(item.completedAt);
      grouped.putIfAbsent(label, () => []).add(item);
    }
    return grouped;
  }

  Widget _dateHeader(String date) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 22.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
