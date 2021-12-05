import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum Categorie {
  sanatate,
  divertisment,
  transport,
  restaurant,
  supermarket,
  servicii,
  electronice
}

class CategoriesSeries {

  static final _colors = {
    Categorie.divertisment: charts.ColorUtil.fromDartColor(Colors.pink),
    Categorie.electronice: charts.ColorUtil.fromDartColor(Colors.blueAccent),
    Categorie.restaurant: charts.ColorUtil.fromDartColor(Colors.red),
    Categorie.sanatate: charts.ColorUtil.fromDartColor(Colors.green),
    Categorie.supermarket: charts.ColorUtil.fromDartColor(Colors.yellow),
    Categorie.servicii: charts.ColorUtil.fromDartColor(Colors.deepOrange),
    Categorie.transport: charts.ColorUtil.fromDartColor(Colors.brown)
  };

  final String categorie;
  final double totalRon;

  CategoriesSeries({required this.categorie, required this.totalRon});
}