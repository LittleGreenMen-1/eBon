import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_bon/services/categories_series.dart';
import '../components/categories_chart.dart';
import 'dart:core';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';
import 'dart:convert';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  List<CategoriesSeries> dataDecember = [
    CategoriesSeries(categorie: 'supermarket', totalRon: 35  ),
    CategoriesSeries(categorie: 'servicii', totalRon: 850),
    CategoriesSeries(categorie: 'transport', totalRon: 50),
    CategoriesSeries(categorie: 'sanatate', totalRon: 150),
  ];
  int totalDecember = 1300;

  List<CategoriesSeries> dataNovember = [
    CategoriesSeries(categorie: 'supermarket', totalRon: 350),
    CategoriesSeries(categorie: 'servicii', totalRon: 700),
    CategoriesSeries(categorie: 'divertisment', totalRon: 400),
    CategoriesSeries(categorie: 'restaurant', totalRon: 250),
  ];
  int totalNovember = 1700;

  List<CategoriesSeries> dataOctober = [
    CategoriesSeries(categorie: 'supermarket', totalRon: 478),
    CategoriesSeries(categorie: 'servicii', totalRon: 458),
    CategoriesSeries(categorie: 'divertisment', totalRon: 200),
    CategoriesSeries(categorie: 'restaurant', totalRon: 500),
  ];
  int totalOctober = 1636;

  List<CategoriesSeries> finalData = [];
  late int totalAmount;

  Future<void> getStatistics(String month) async {
    List<CategoriesSeries> data = [];

    firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref('/Data').listAll();

    result.items.forEach((firebase_storage.Reference ref) async{
      Uint8List? downloadedData  =  await ref.getData();

      String jsonData = utf8.decode(downloadedData!);
      Map<String, dynamic> map = jsonDecode(jsonData);

      if(map['date'].split(RegExp(r'[-.\/\\]'))[1] == '12' || map['date'].split(RegExp(r'[-.\/\\]'))[1] == '11' || map['date'].split(RegExp(r'[-.\/\\]'))[1] == '10') {
        print(map['date'].split(RegExp(r'[-.\/\\]'))[1]);
        if (data.isEmpty) {
          setState(() {
            data.add(CategoriesSeries(
                categorie: map['category'],
                totalRon: double.parse(map['total'])));
          });
        } else {
            bool found = false;
            for(var c in data){
              if(c.categorie == map['category']){
                found = true;
                setState(() {
                  c.totalRon += double.parse(map['total']);
                });
                break;
              }
            }
            if(found == false){
              setState(() {
                data.add(CategoriesSeries(
                    categorie: map['category'],
                    totalRon: double.parse(map['total'])));
              });
            }
        }
      }
    });
  }

  String dropdownValue = 'decembrie';

  @override
  void initState(){
    super.initState();
    setState(() {
      switch (dropdownValue){
        case 'decembrie': totalAmount = totalDecember; finalData = dataDecember; break;
        case 'octombrie': totalAmount = totalOctober; finalData = dataOctober; break;
        case 'noiembrie': totalAmount = totalNovember; finalData = dataNovember; break;
      }
     });
  }

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
                  const Text("Cheltuielile tale: "),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: Colors.lightBlue),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          switch (dropdownValue){
                            case 'decembrie': totalAmount = totalDecember; finalData = dataDecember; break;
                            case 'octombrie': totalAmount = totalOctober; finalData = dataOctober; break;
                            case 'noiembrie': totalAmount = totalNovember; finalData = dataNovember; break;
                          }
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
                height: 10,
              ),
              CategoriesChart(
                data: finalData,
                totalAmountSpent: totalAmount,
              ),
            ]
          ),
        ),
      ),
    );
  }
}
