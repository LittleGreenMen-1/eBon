import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class HomeButton extends StatelessWidget {
  HomeButton({required this.onTap, required this.buttonTitle, required this.underline});

  final VoidCallback onTap;
  final String buttonTitle;
  final Widget underline;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        color: Colors.blue,
        child: Center(
            child: Column(
                children: <Widget>[
                  Text(buttonTitle, style: kLargeButtonTextStyle,),
                  underline,
                ]
            )
        ),
      ),
    );
  }
}