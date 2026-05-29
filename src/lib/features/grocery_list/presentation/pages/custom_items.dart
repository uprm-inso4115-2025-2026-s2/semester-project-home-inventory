import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';
import 'package:src/core/presentation/widgets/top.dart';

class CustomItems extends StatelessWidget {
  const CustomItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocBuilder<GroceryListCubit, GroceryListState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            children: [
              Top(
                color: Colors.black,
                leftButton: () => context.pop(),
                title: "Edit Custom Items",
                iconColor: primary,
              ),
              SizedBox(height: 2.h),
              MySearchBar(),
              SizedBox(height: 2.h),
              if (state.customCollectionItems.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Center(
                    child: Text(
                      'No custom items to edit.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.customCollectionItems.length,
                  itemBuilder: (context, index) {
                    final item = state.customCollectionItems[index];
                    return ItemTile(
                      title: item.name,
                      isCustom: true,
                      imageUrl: item.imagePath,
                      onRemove: () => sl<GroceryListCubit>()
                          .removeCustomCollectionItem(item.id),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
