import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/theme.dart';

class ReportsOverviewPage extends StatelessWidget {
  const ReportsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor comes from AppTheme.lightTheme (backgroundColor = 0xFFFBF7EF)
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),

              //Page Title
              Text(
                'Reports Overview',
                style: Theme.of(context).textTheme.displayMedium,
              ),

              SizedBox(height: 4.h),

              //Report Cards
              _ReportCard(
                label: 'Inventory Stock Summary',
                icon: Icons.inventory_2_outlined,
                onTap: () => context.go('/home/reports/inventory-stock-summary'),
              ),

              SizedBox(height: 3.h),

//TO DO: Navigate to Item Usage Rates screen once implemented
              _ReportCard(
                label: 'Item Usage Rates',
                icon: Icons.bar_chart_rounded,
                onTap: () => context.go('/home/reports/item-usage-rates'),
              ),

              SizedBox(height: 3.h),

//TO DO: Navigate to Expenditures screen once implemented
              _ReportCard(
                label: 'Expenditures',
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => context.go('/home/reports/expenditures'),
              ),

              //Bottom bar space (for dashboard bar)
              const Spacer(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

///Tappable dark-green report card with a centred icon and a bold label above it.
class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Label sits above the card, bold
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 1.h),

        //The green card itself
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 18.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor, //#3A5A40 dark green
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 18.w,
                color: AppTheme.accentColor.withOpacity(0.85), //muted sage icon
              ),
            ),
          ),
        ),
      ],
    );
  }
}