import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:e_bon/services/categories_series.dart';

class Receipt extends StatelessWidget {
  String title;
  String date;
  String total;
  String? category;

  Map<String, IconData> category_icon = {
    "sanatate": Icons.health_and_safety_outlined,
    "divertisment": Icons.golf_course_outlined,
    "transport": Icons.emoji_transportation_outlined,
    "restaurant": Icons.local_dining_outlined,
    "supermarket": Icons.local_convenience_store_rounded,
    "electronice": Icons.electrical_services_outlined,
    "servicii": Icons.construction_outlined,
    "altele": Icons.receipt_long_outlined
  };

  Receipt(
      {required this.title,
      required this.date,
      required this.total,
      this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 10.0, right: 20.0, top: 20.0, bottom: 20.0),
      margin: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(-1, 1),
            )
          ]),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Icon(category_icon[category ?? "altele"])),
          const SizedBox(width: 15.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Text(date,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 84, 84, 84),
                        fontSize: 15.0)),
              ],
            ),
          ),
          Expanded(
              child: Text(total,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
