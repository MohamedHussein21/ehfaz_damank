import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/statistics_screen/presentation/cubit/statistics_screen_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/statistics_model.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsScreenCubit()..getStatistics(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إحصائيات فواتيرك',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<StatisticsScreenCubit, StatisticsScreenState>(
          builder: (context, state) {
            if (state is StatisticsScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatisticsScreenError) {
              return const Center(child: Text("حدث خطأ أثناء جلب البيانات!"));
            } else if (state is StatisticsScreenSuccess) {
              return _buildStatisticsContent(context, state.statistics);
            } else {
              return const Center(child: Text("لا توجد بيانات متاحة."));
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsContent(BuildContext context, StatisticsModel model) {
    return SingleChildScrollView(
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
            _buildPieChart(model.data.categories),
            SizedBox(height: MediaQueryValue(context).heigh * 0.05),
            const Text(
              "اتجاه الإنفاق الشهري",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.05),
            _buildLineChart(model.data.monthlySpending),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<Category> categories) {
    List<PieChartSectionData> sections = categories.map((category) {
      return PieChartSectionData(
        value: category.percentage.toDouble(),
        color: _getRandomColor(category.categoryId),
        title: "${category.percentage}%",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildLineChart(List<MonthlySpending> monthlySpending) {
    List<FlSpot> spots = monthlySpending.asMap().entries.map((entry) {
      int index = entry.key;
      double totalSpent = double.tryParse(entry.value.totalSpent) ?? 0;
      return FlSpot(index.toDouble(), totalSpent);
    }).toList();

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
                  int index = value.toInt();
                  if (index >= 0 && index < monthlySpending.length) {
                    return Text(
                      monthlySpending[index].month,
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: monthlySpending.length.toDouble() - 1,
          minY: 0,
          maxY: _getMaxY(monthlySpending),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
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

  double _getMaxY(List<MonthlySpending> spending) {
    double maxValue = spending
        .map((e) => double.tryParse(e.totalSpent) ?? 0)
        .fold(0, (prev, current) => current > prev ? current : prev);
    return maxValue + (maxValue * 0.2); // إضافة هامش 20%
  }

  Color _getRandomColor(int categoryId) {
    List<Color> colors = [
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.blue,
      Colors.red,
      Colors.teal
    ];
    return colors[categoryId % colors.length];
  }
}
