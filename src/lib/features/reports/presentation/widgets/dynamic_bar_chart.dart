import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:src/config/theme.dart';

//TO DO: Replace with real data from Supabase backend when available
//This widget accepts dynamic data but currently uses placeholder data structure
class DynamicBarChart extends StatelessWidget {
  final List<CategoryData> data;
  
  const DynamicBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 200,
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

    final maxVal = data.map((e) => e.quantity).reduce((a, b) => a > b ? a : b);
    final safeMaxVal = maxVal == 0 ? 100 : maxVal;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: safeMaxVal.toDouble(),
                barGroups: _createBarGroups(data, safeMaxVal),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[index].name,
                              style: const TextStyle(fontSize: 11, color: Colors.black),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: (safeMaxVal / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
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
                      color: Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey[800],
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${data[group.x.toInt()].quantity}',
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
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              //This will need to be adapted based on your cubit
              //For now, just showing a placeholder or you can inject page info
              return const Text(
                '< Page 1 >',
                style: TextStyle(color: Colors.black),
              );
            },
          ),
        ],
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
            width: 40,
            borderRadius: BorderRadius.circular(4),
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