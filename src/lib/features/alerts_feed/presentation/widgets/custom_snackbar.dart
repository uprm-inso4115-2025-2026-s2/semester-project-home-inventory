import 'package:flutter/material.dart';
import 'package:src/config/theme.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required String message, super.elevation})
    : super(
        content: Center(
          child: Builder(
            builder: (context) {
              return Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        backgroundColor: AppTheme.mutedText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
}
