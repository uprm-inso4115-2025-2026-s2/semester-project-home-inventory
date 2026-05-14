import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:src/config/theme.dart';

//TO DO: Replace with real data from Supabase backend when available
class DynamicPieChart extends StatelessWidget {
  final List<ExpenditureCategory> categories;
  
  const DynamicPieChart({
    super.key, 
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Text('No data available for chart'),
        ),
      );
    }

    final total = categories.fold(0.0, (sum, c) => sum + c.amount);
    if (total == 0) {
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Text('No expenditure data available'),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          sections: _createSections(categories, total),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(
            enabled: true,
            touchTooltipData: PieTouchTooltipData(
              getTooltipItem: (touchedSection) {
                final category = categories[touchedSection.sectionIndex];
                final percentage = (category.amount / total * 100);
                return PieTooltipItem(
                  '${category.name}\n\$${category.amount.toStringAsFixed(2)}\n${percentage.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections(List<ExpenditureCategory> categories, double total) {
    return List.generate(categories.length, (index) {
      final category = categories[index];
      final percentage = category.amount / total;
      final showPercentage = percentage > 0.05; // Only show label if slice is large enough
      
      return PieChartSectionData(
        value: percentage,
        title: showPercentage ? '${(percentage * 100).round()}%' : '',
        color: category.color,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });
  }
}