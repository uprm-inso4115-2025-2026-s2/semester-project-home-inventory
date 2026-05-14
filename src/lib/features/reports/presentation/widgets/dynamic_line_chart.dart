import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:src/config/theme.dart';

// TODO: Replace with real data from Supabase backend when available
class DynamicLineChart extends StatelessWidget {
  final List<double> points;
  final List<String> days;
  
  const DynamicLineChart({
    super.key, 
    required this.points, 
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty || days.isEmpty) {
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

    // Calculate min and max for Y-axis
    final minY = 0.0;
    final maxY = points.reduce((a, b) => a > b ? a : b);
    final safeMaxY = maxY == 0 ? 30.0 : maxY + 5; // Add 5 for padding

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(points.length, (index) {
                  return FlSpot(index.toDouble(), points[index]);
                }),
                isCurved: false,
                color: AppTheme.primaryColor,
                barWidth: 2,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppTheme.backgroundColor,
                      strokeWidth: 2,
                      strokeColor: AppTheme.primaryColor,
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          days[index],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
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
                  reservedSize: 35,
                  interval: 10,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
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
              horizontalInterval: 10,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppTheme.borderColor.withOpacity(0.5),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                // tooltipBgColor removed - not supported in this version
                getTooltipItem: (touchedSpot) {
                  return LineTooltipItem(
                    touchedSpot.y.toInt().toString(),
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
    );
  }
}