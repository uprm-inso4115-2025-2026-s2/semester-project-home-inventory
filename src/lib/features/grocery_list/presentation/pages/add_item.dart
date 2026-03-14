import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/widgets/text_field.dart';
import 'package:src/features/grocery_list/presentation/widgets/top.dart';
import 'package:src/features/grocery_list/presentation/widgets/upload_image.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, this.isCustom = false});
  final bool isCustom;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController name = TextEditingController();
  File? itemImage;

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
            title: widget.isCustom ? "Edit Item" : "Add Item",
            iconColor: primary,
          ),
          SizedBox(height: 2.h),
          itemTile(),
          SizedBox(height: 2.h),
          BuildTextField(
            label: 'Name',
            controller: name,
            isSmall: false,
            hintText: 'Item Name',
            required: true,
            padding: false,
            isDarkMode: true,
          ),
          SizedBox(height: 2.h),
          UploadImage(
            image: itemImage,
            chooseImg: () {},
            isPdf: false,
            color: Colors.black,
            title: 'Item Image',
            changeButtonColor: secondary,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
        child: CupertinoButton(
          onPressed: () {
            context.pop();
          },
          color: primary,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          borderRadius: BorderRadius.circular(15),
          child: Text(
            widget.isCustom ? "Edit Item" : "Add Item",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
      ),
    );
  }

  Widget itemTile() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: SizedBox(
          width: 45.w,
          height: 20.h,
          child: Container(
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 1.h),
                Container(color: Colors.red, width: 20.w, height: 10.h),
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
        ),
      ),
    );
  }
}
