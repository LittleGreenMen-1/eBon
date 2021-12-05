import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'receipts_page.dart';
import 'stats_page.dart';
import '../components/home_button.dart';
import '../constants.dart';
import '../services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('eBon'),
          centerTitle: true,
          /*actions: [
            IconButton(
                onPressed: () async{
                  await _auth.signOut();
                },
                icon: const Icon(Icons.logout))
          ],*/
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bonuri'),
              Tab(text: 'Scan'),
              Tab(text: 'Statistici')
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReceiptsPage(),
            ScanPage(),
            StatsPage()
          ],
        ),
      ),
    );
  }
}
