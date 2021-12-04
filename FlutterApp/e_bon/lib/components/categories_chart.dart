import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:e_bon/services/categories_series.dart';

class CategoriesChart extends StatelessWidget {
  final List<CategoriesSeries> data;

  CategoriesChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CategoriesSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (CategoriesSeries series, _) => series.categorie,
          measureFn: (CategoriesSeries series, _) => series.totalRon,
          colorFn: (CategoriesSeries series, _) => series.barColor
      )
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Cheltuieli totale",
              ),
              Expanded(
                child: charts.PieChart(series, animate: true),
              ),
              Expanded(
                flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

