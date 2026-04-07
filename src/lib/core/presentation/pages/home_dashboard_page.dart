import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/presentation/widgets/dashboard_card.dart';
import 'package:src/core/presentation/widgets/stat_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repositories.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/features/auth/presentation/pages/auth_landing_page.dart';

/// Home page displaying the inventory dashboard with charts and statistics
class HomeDashboardPage extends StatelessWidget {
  final bool isEmpty;

  const HomeDashboardPage({super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DashboardCubit(sl<DashboardRepository>())..fetchInitialData(),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final now = DateTime.now();
          final dateFormatter = _formatDate(now);

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, theme, dateFormatter),
            body: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DashboardLoaded) {
                  final items = state.items;

                  final totalItems = items.length;
                  final totalValue = items.fold<double>(
                    0,
                    (sum, item) => sum + item.value,
                  );

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: _buildDashboardContent(
                      context,
                      totalItems,
                      totalValue,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds the empty state when no items are added
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Text(
                  'No items added yet.',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Start building your inventory.',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () {
                    // Add item action
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    overlayColor: theme.scaffoldBackgroundColor.withOpacity(
                      0.2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.5.w,
                      vertical: 1.3.h,
                    ),
                  ),
                  child: Text(
                    'Add Item',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 16.sp,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        // Stat Cards Row 1
        Row(
          children: [
            Expanded(
              child: StatCard(label: 'Total Items', value: '0'),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: StatCard(label: 'Inventory Value', value: '\$0.00'),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        // Stat Cards Row 2
        Row(
          children: [
            Expanded(
              child: StatCard(label: 'Pending Alerts', value: '0'),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: StatCard(label: 'Categories Tracked', value: '0'),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  /// Builds the main dashboard content with cards and statistics
  Widget _buildDashboardContent(
    BuildContext context,
    int totalItems,
    double totalValue,
  ) {
    final reportsNavigate = () => context.go('/home/reports');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _buildFilters(context),
        ),
        // Inventory Value Trend Card
        DashboardCard(
          title: 'Inventory Value Trend',
          onTap: reportsNavigate,
          child: _buildChartPlaceholder(context, 'Line Chart'),
        ),
        SizedBox(height: 1.5.h),
        // Category Distribution Card
        DashboardCard(
          title: 'Category Distribution',
          onTap: reportsNavigate,
          child: _buildChartPlaceholder(context, 'Pie Chart'),
        ),
        SizedBox(height: 1.5.h),
        // Stat Cards Row 1
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Total Items',
                value: '$totalItems',
                onTap: reportsNavigate,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: StatCard(
                label: 'Inventory Value',
                value: '\$${totalValue.toStringAsFixed(2)}',
                onTap: reportsNavigate,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        // Stat Cards Row 2
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Pending Alerts',
                value: '13',
                onTap: reportsNavigate,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: StatCard(
                label: 'Categories Tracked',
                value: '5',
                onTap: reportsNavigate,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  /// Builds the app bar with logo, title, and profile icon
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    String dateFormatter,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: Image.asset(
                  'assets/images/homeinventorylogo.png',
                  width: 6.5.w,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Home Inventory',
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 18.sp),
              ),
            ],
          ),
          Text(
            dateFormatter,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AuthLandingPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.account_circle,
                color: theme.colorScheme.primary,
                size: 8.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a placeholder for chart content
  Widget _buildChartPlaceholder(BuildContext context, String chartType) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            color: theme.colorScheme.surface.withOpacity(0.4),
            size: 12.w,
          ),
          SizedBox(height: 1.5.h),
          Text(
            chartType,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.surface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    String? selectedCategory;
    String? selectedRoom;
    DateTime? startDate;
    DateTime? endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Category"),
          items: ["Electronics", "Furniture", "Clothing"]
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
          onChanged: (value) {
            selectedCategory = value;
          },
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Room"),
          items: ["Living Room", "Bedroom", "Kitchen"]
              .map((room) => DropdownMenuItem(value: room, child: Text(room)))
              .toList(),
          onChanged: (value) {
            selectedRoom = value;
          },
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<DashboardCubit>().applyFilters(
                  category: selectedCategory,
                  room: selectedRoom,
                  startDate: startDate,
                  endDate: endDate,
                );
              },
              child: const Text("Apply Filters"),
            ),

            const SizedBox(width: 12),

            OutlinedButton(
              onPressed: () {
                context.read<DashboardCubit>().clearFilters();
              },
              child: const Text("Clear"),
            ),
          ],
        ),
      ],
    );
  }

  /// Formats the current date in a readable format
  static String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return '$dayName, ${monthName.substring(0, 3)} ${date.day}';
  }
}
