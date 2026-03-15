import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/grocery_list/data/constants.dart';

class BuildTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isDarkMode;
  final bool isSmall;
  final bool isPassword;
  final bool autocorrect;
  final bool isNumber;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final bool padding;
  final int? length;
  final bool paragraph;
  final bool required;
  final Function(String)? onChange;
  final Color fieldColor;
  final Color color;
  final Color textColor;
  final bool enable;

  const BuildTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isSmall,
    required this.hintText,
    this.required = false,
    this.paragraph = false,
    this.isNumber = false,
    this.length,
    this.padding = false,
    this.isPassword = false,
    this.isDarkMode = true,
    this.autocorrect = false,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.onChange,
    this.fieldColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.black,
    this.color = const Color(0xFFF5F5F5),
    this.enable = true,
  });

  @override
  BuildTextFieldState createState() => BuildTextFieldState();
}

class BuildTextFieldState extends State<BuildTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding
          ? EdgeInsets.symmetric(horizontal: 2.w)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
                ),
                if (widget.required) ...[
                  SizedBox(width: 4),
                  Text(
                    '*',
                    textScaler: TextScaler.noScaling,
                    maxLines: 1,
                    style: TextStyle(color: Colors.red, fontSize: 20.sp),
                  ),
                ],
              ],
            ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              color: widget.fieldColor,
              borderRadius: BorderRadius.circular(16),
            ),
            width: widget.isSmall ? 40.w : 90.w,
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword && !_isPasswordVisible,
              style: TextStyle(color: Colors.black, fontSize: 15.sp),
              keyboardType: widget.keyboardType,
              inputFormatters: widget.isNumber
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              onChanged: widget.onChange,
              enabled: widget.enable,
              maxLines: widget.paragraph ? null : 1,
              onTap: widget.onTap,
              maxLength: widget.length,
              readOnly: widget.onTap != null,
              autocorrect: widget.autocorrect,
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.fieldColor,
                hoverColor: secondary,
                suffixIcon: widget.isPassword
                    ? CupertinoButton(
                        padding: EdgeInsets.only(right: 3.w),
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: secondary,
                          size: 2.5.h,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                    : null,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: secondary, fontSize: 16.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: secondary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: secondary, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
