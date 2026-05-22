import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';

/// Content shown when "My Grocery List" tab is selected on the home screen.
class MyGroceryListPage extends StatelessWidget {
  const MyGroceryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryListCubit, GroceryListState>(
      builder: (context, state) {
        return Column(
          children: [
            MySearchBar(),
            SizedBox(height: 2.h),
            Expanded(
              child: state.items.isEmpty
                  ? Center(
                      child: Text(
                        'Your grocery list is empty.\nTap an item in a collection to add it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ItemTile(
                          title: item.name,
                          itemId: item.id,
                          quantity: item.quantity,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
