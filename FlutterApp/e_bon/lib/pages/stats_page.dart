import 'package:flutter/material.dart';
import 'package:e_bon/services/categories_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../components/categories_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  final List<CategoriesSeries> data = [
    CategoriesSeries(
      categorie: 'divertismet',
      totalRon: 2500,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    CategoriesSeries(
      categorie: 'electronice',
      totalRon: 4500,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CategoriesChart(
          data: data,
        )
    );
  }
}
