import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:src/config/theme.dart';
import '../cubit/inventory_stock_report_state.dart';

//TO DO: Replace with real data from Supabase backend when available
class DynamicBarChart extends StatelessWidget {
  final List<CategoryData> data;
  
  const DynamicBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 300,
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

    // Get screen height for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    // Increase to 45% of screen height to leave room for tooltips
    double chartHeight = screenHeight * 0.45;
    
    // Adjust for very small screens - ensure minimum height
    if (chartHeight < 350) {
      chartHeight = 350;
    }

    final maxVal = data.map((e) => e.quantity).reduce((a, b) => a > b ? a : b);
    // Add 30% padding to the top so tooltips and numbers have room
    final safeMaxVal = maxVal == 0 ? 100.0 : (maxVal * 1.3).toDouble();
    
    // Bar width for better spacing
    const double barWidth = 100;
    final double chartWidth = data.length * barWidth;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          height: chartHeight,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: safeMaxVal,
              barGroups: _createBarGroups(data, safeMaxVal),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                          child: Text(
                            data[index].name,
                            style: TextStyle(
                              fontSize: 11, 
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 45,
                    interval: (safeMaxVal / 5).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (safeMaxVal / 5).ceilToDouble(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.borderColor.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  // Position the tooltip above the bar
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final value = data[group.x.toInt()].quantity;
                    return BarTooltipItem(
                      value.toString(),
                      TextStyle(
                        color: AppTheme.surfaceColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(List<CategoryData> data, double maxVal) {
    return List.generate(data.length, (index) {
      final category = data[index];
      final height = category.quantity.toDouble();
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: height,
            color: AppTheme.accentColor,
            width: 60,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxVal,
              color: Colors.grey[200],
            ),
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }
}