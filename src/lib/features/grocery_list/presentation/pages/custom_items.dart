import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';
import 'package:src/features/grocery_list/presentation/widgets/top.dart';

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
              searchBar(context),
              SizedBox(height: 2.h),
              itemsList(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: primary,
                size: 18.sp,
              ),
              placeholder: 'Search an Item',
              placeholderStyle: TextStyle(
                fontSize: 16.5.sp,
                color: Colors.grey[700],
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
              style: TextStyle(color: Colors.black),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
                border: Border.all(color: secondary, width: 0.8.w),
              ),
              onChanged: (value) {},
            ),
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
