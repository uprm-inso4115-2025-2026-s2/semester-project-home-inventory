import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/widgets/item_tile.dart';

/// Content shown when "My Grocery List" tab is selected on the home screen.
class MyGroceryListPage extends StatefulWidget {
  const MyGroceryListPage({super.key});

  @override
  State<MyGroceryListPage> createState() => _MyGroceryListPageState();
}

class _MyGroceryListPageState extends State<MyGroceryListPage> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        MySearchBar(),
        SizedBox(height: 2.h),
        item(context),
      ],
    );
  }

  Widget item(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) => ItemTile(title: 'title'),
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
}
