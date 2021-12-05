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

  final PageController _controller = PageController(
    initialPage: 1,
  );

  //TODO: schimba style-ul la butoane dupa ce sunt apasate cu enum
  //TODO: ADADADA

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                HomeButton(buttonTitle: 'Bonuri', onTap: (){
                  setState(() {
                    _controller.animateToPage(0, duration: kDuration, curve: kCurve);
                  });
                },),
                HomeButton(buttonTitle: 'Scan', onTap: (){
                  setState(() {
                    _controller.animateToPage(1, duration: kDuration, curve: kCurve);
                  });
                },),
                HomeButton(buttonTitle: 'Statistici', onTap: (){
                  setState(() {
                    _controller.animateToPage(2, duration: kDuration, curve: kCurve);
                  });
                },),
              ],
            ),
          ),
          Expanded(
            flex: 12,
            child: PageView(
              controller: _controller,
              children: const [
                ReceiptsPage(),
                ScanPage(),
                StatsPage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
