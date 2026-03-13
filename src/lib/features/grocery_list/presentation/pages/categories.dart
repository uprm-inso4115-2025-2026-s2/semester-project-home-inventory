import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/widgets/top.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          Top(
            color: Colors.black,
            leftButton: () => context.pop(),
            title: "Vegetables",
            iconColor: primary,
          ),
          searchBar(context),
          SizedBox(height: 2.h),
          item(),
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

  Widget item() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => itemTile(),
    );
  }

  Widget itemTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Container(
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 1.h),
            Container(color: Colors.red, width: 10.w, height: 5.h),
            Text(
              "Item",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}
