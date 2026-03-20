import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
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
}
