import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';
import 'package:src/core/presentation/widgets/top.dart';

class CustomItems extends StatelessWidget {
  const CustomItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          Column(
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
              itemsList(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ItemTile(title: "Item $index", isCustom: true);
      },
    );
  }
}
