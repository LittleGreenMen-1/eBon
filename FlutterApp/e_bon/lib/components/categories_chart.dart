import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:e_bon/services/categories_series.dart';

class CategoriesChart extends StatelessWidget {
  final List<CategoriesSeries> data;
  final int totalAmountSpent;

  CategoriesChart({required this.data, required this.totalAmountSpent});
  
  Map<String, double>chartData = {};
  void _mapData() {
    for (var e in data) {
      chartData[e.categorie] = e.totalRon;
    }
  }

  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {

    _mapData();

    return PieChart(
      dataMap: chartData,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 1.5,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: '$totalAmountSpent Ron',
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}

