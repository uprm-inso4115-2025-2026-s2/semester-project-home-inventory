import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// A reusable card widget for displaying statistics
/// Displays a label and a large value in a Material 3 style green card
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = height ?? 20.h;

    final card = Container(
      width: width ?? size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Label - positioned near top
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 16.sp,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            // Spacer to push value to vertical center
            const Spacer(),
            // Value with stroke effect - layered texts
            SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Stroke layer
                    Text(
                      value,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 20.sp,
                        foreground: Paint()
                          ..strokeWidth = 2
                          ..color = theme.colorScheme.secondary
                          ..style = PaintingStyle.stroke,
                      ),
                    ),
                    // Fill layer
                    Text(
                      value,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Spacer to balance and keep value centered
            const Spacer(),
          ],
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}
