import 'package:e_bon/pages/home_page.dart';
import 'package:e_bon/pages/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth.dart';
import 'pages/wrapper.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const eBon());
}

class eBon extends StatelessWidget {
  const eBon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eBon',
      home: HomePage(),
    );
  }
}