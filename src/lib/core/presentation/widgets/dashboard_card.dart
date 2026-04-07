import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// A reusable card widget for displaying charts or large data visualizations
/// Can be used for line charts, pie charts, or other dashboard content
class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Container(
      height: height ?? 22.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(3.5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title - using Poppins SemiBold 16sp from theme
            Text(
              title,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 16.sp,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            SizedBox(height: 2.5.h),
            // Content
            Expanded(child: child),
          ],
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}
