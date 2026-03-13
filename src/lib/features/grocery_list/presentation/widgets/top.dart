import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Top extends StatelessWidget {
  final Color color;

  final Widget? replacedBackButton;
  final Function() leftButton;
  final IconData? icon;
  final String? leftButtonText;
  final Widget? widget;
  final bool? addButton;
  final Function()? addFunction;
  final bool? padding;
  final String? title;
  final IconData? addIcon;
  final Color? backgroundColor;
  final Function(String value)? onChanged;
  final Widget? secondWidget;
  final Widget? thirdWidget;
  final Widget? titleWidget;
  final bool showSearch;
  final FocusNode? focusNode;
  final Function()? onTitleTap;
  final Color? buttonColor;
  final Color? iconColor;

  const Top({
    super.key,
    this.widget,
    required this.color,
    required this.leftButton,
    this.icon,
    this.leftButtonText,
    this.replacedBackButton,
    this.titleWidget,
    required this.title,
    this.addButton,
    this.addFunction,
    this.padding,
    this.addIcon,
    this.backgroundColor,
    this.onChanged,
    this.secondWidget,
    this.showSearch = false,
    this.focusNode,
    this.onTitleTap,
    this.thirdWidget,
    this.buttonColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(
        top: 7.h,
        left: padding == true ? 6.w : 1.w,
        right: padding == true ? 6.w : 1.w,
        bottom: 1.h,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(10000),
                color: buttonColor,
                onPressed: leftButton,
                child: leftButtonText != null && leftButtonText!.isNotEmpty
                    ? Text(
                        leftButtonText!,
                        style: TextStyle(
                          color: iconColor ?? Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Icon(
                        icon ?? CupertinoIcons.back,
                        color: iconColor ?? Colors.black,
                        size: 24.sp,
                      ),
              ),

              SizedBox(
                width: 60.w,
                child: Text(
                  title!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: color,
                    decoration: TextDecoration.none,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget != null) widget!,
              if (widget == null) add(context),
            ],
          ),
          if (showSearch) ...[SizedBox(height: 2.h), searchBar(context)],
        ],
      ),
    );
  }

  Widget add(BuildContext context) {
    return GestureDetector(
      onTap: addFunction,
      child: Icon(
        addIcon ?? CupertinoIcons.add,
        size: 25.sp,
        color: addButton == null ? Colors.transparent : iconColor,
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              focusNode: focusNode,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: color,
                size: 18.sp,
              ),
              placeholder: 'Buscar',
              placeholderStyle: TextStyle(
                fontSize: 16.5.sp,
                color: Colors.grey[700],
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
              style: TextStyle(color: color),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color),
              ),
              onChanged: onChanged,
            ),
          ),
          if (secondWidget != null) ...[SizedBox(width: 4.w), secondWidget!],
          if (thirdWidget != null) ...[SizedBox(width: 4.w), thirdWidget!],
        ],
      ),
    );
  }
}
