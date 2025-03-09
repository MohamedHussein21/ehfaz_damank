import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إحصائيات فواتيرك',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQueryValue(context).toPadding * 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "تصنيف الفواتير حسب الفئات",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQueryValue(context).heigh * 0.05),
              _buildPieChart(),
              SizedBox(height: MediaQueryValue(context).heigh * 0.05),
              const Text(
                "اتجاه الإنفاق الشهري",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQueryValue(context).heigh * 0.05),
              _buildLineChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            _buildPieChartSection(32, Colors.green, "32%"),
            _buildPieChartSection(20, Colors.orange, "20%"),
            _buildPieChartSection(20, Colors.purple, "20%"),
            _buildPieChartSection(20, Colors.blue, "20%"),
            _buildPieChartSection(8, Colors.grey, "8%"),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  PieChartSectionData _buildPieChartSection(
      double value, Color color, String label) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: label,
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    "يناير",
                    "فبراير",
                    "مارس",
                    "أبريل",
                    "مايو",
                    "يونيو",
                    "يوليو"
                  ];
                  return Text(months[value.toInt() % months.length],
                      style: const TextStyle(fontSize: 12));
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 3500,
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1000),
                const FlSpot(1, 1500),
                const FlSpot(2, 1200),
                const FlSpot(3, 1800),
                const FlSpot(4, 3000),
                const FlSpot(5, 2500),
                const FlSpot(6, 2000),
              ],
              isCurved: true,
              color: Colors.purple,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                  show: true, color: Colors.purple.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
