import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:e_bon/components/receipt.dart';
import 'package:e_bon/pages/view_receipt.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({Key? key}) : super(key: key);

  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _data = [];
  List<String> _URLs = [];

  @override
  void initState() {
    super.initState();

    getReceiptsData();
    getLinks();
  }

  Future<void> getReceiptsData() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref("Data").listAll();

    List<Map<String, dynamic>> final_data = [];

    for (var ref in result.items) {
      ref.getData().then((data) {
        String jsonData = utf8.decode(data!);
        Map<String, dynamic> map = jsonDecode(jsonData);

        setState(() {
          _data.add(map);
        });
      });
    }
  }

  Future<void> getLinks() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref("Receipt")
        .listAll();

    for (var ref in result.items) {
      ref.getDownloadURL().then((data) {
        setState(() {
          _URLs.add(data);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data != null ? _data.length : 0,
      itemBuilder: (BuildContext context, int index) {
        if (_data != null && _data != []) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewReceipt(url: _URLs[index])));
            },
            child: Receipt(
              title: _data[index]["name"]!,
              date: _data[index]["date"]!,
              total: _data[index]["total"]!,
              category: _data[index]["category"]!,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
