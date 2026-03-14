import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/features/grocery_list/data/constants.dart';

/// Content shown when "Collections" tab is selected on the home screen.
class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        searchBar(context),
        SizedBox(height: 2.h),
        collection(context),
      ],
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

  Widget collection(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) =>
          collectionCard(context, "title", CupertinoIcons.bag_fill),
    );
  }

  Widget collectionCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        AppRouter.goTo(context, "categories");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Container(
          width: 10.w,
          height: 15.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 6.w),
              Icon(icon, size: 43.sp, color: secondary),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
