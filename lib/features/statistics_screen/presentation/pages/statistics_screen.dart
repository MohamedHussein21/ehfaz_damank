import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/statistics_screen/presentation/cubit/statistics_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "bills statistics".tr(),
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<StatisticsScreenCubit, StatisticsScreenState>(
            builder: (context, state) {
              if (state is StatisticsScreenLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StatisticsScreenError) {
                return Center(child: Text("something went wrong".tr()));
              } else if (state is StatisticsScreenSuccess) {
                return _buildStatisticsContent(context, state.statistics);
              } else {
                return Center(child: Text("no data available".tr()));
              }
            },
          ),
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
            Text(
              "bills by category".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.05),
            if (model.data.categories.isEmpty)
              Center(
                child: Image(
                  image: AssetImage(ImageAssets.frame),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Center(
                  child: _buildPieChart(
                model.data.categories,
              )),
            Text(
              "monthly expenses".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.05),
            _buildCategoryBarChart(model.data.categories),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<Category> categories) {
    List<PieChartSectionData> sections = categories.map((category) {
      return PieChartSectionData(
        value: category.percentage.toDouble(),
        color: _getColorForCategory(category.categoryId),
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

  Widget _buildCategoryBarChart(List<Category> categories) {
    List<BarChartGroupData> barGroups = categories.asMap().entries.map((entry) {
      int index = entry.key;
      double totalAmount = entry.value.totalAmount.toDouble();
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalAmount,
            color: _getColorForCategory(entry.value.categoryId),
            width: 20,
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 230,
      child: BarChart(
        BarChartData(
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
                  if (index >= 0 && index < categories.length) {
                    return Text(
                      categories[index].categoryName,
                      style: const TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
          minY: 0,
          maxY: _getMaxY(categories),
        ),
      ),
    );
  }

  double _getMaxY(List<Category> categories) {
    double maxAmount = 0.0;
    for (var category in categories) {
      if (category.totalAmount > maxAmount) {
        maxAmount = category.totalAmount.toDouble();
      }
    }
    return maxAmount;
  }

  Color _getColorForCategory(int categoryId) {
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
