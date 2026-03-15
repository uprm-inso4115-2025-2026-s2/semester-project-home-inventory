import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/core/presentation/widgets/top.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, this.isCustom = true});
  final bool isCustom;

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
            widget: isCustom ? customButton(context) : null,
          ),
          MySearchBar(),
          SizedBox(height: 2.h),
          item(),
        ],
      ),
    );
  }

  Widget customButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.goTo(context, "custom_items");
      },
      child: Text(
        "Edit",
        style: TextStyle(
          fontSize: 18.sp,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
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
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}
