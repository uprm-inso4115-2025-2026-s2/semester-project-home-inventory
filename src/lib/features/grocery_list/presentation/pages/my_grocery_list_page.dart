import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';

/// Content shown when "My Grocery List" tab is selected on the home screen.
class MyGroceryListPage extends StatelessWidget {
  const MyGroceryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [],
    );
  }
}
