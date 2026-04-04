import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.buttonText});

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      child: CupertinoButton(
        onPressed: () {
          context.pop();
        },
        color: primary,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        borderRadius: BorderRadius.circular(15),
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }
}
