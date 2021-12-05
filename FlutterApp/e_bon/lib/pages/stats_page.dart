import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_bon/services/categories_series.dart';
import '../components/categories_chart.dart';
import 'dart:core';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  String dropdownValue = 'decembrie';

  final List<CategoriesSeries> data = [
    CategoriesSeries(
      categorie: 'divertismet',
      totalRon: 2500,
    ),
    CategoriesSeries(
      categorie: 'electronice',
      totalRon: 4500,
    ),
    CategoriesSeries(
      categorie: 'dasdas',
      totalRon: 4500,
    ),
    CategoriesSeries(
      categorie: 'elecdasdastronice',
      totalRon: 4500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Cheltuielile tale: "),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: Colors.lightBlue),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['decembrie', 'noiembrie', 'octombrie']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CategoriesChart(
                data: data,
                totalAmountSpent: 45858,
              ),
            ]
          ),
        ),
      ),
    );
  }
}
