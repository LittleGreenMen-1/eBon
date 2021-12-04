import 'package:flutter/material.dart';
import '../constants.dart';

class HomeButton extends StatelessWidget {
  HomeButton({required this.onTap, required this.buttonTitle});

  final VoidCallback onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        child: Center(
            child: Text(buttonTitle, style: kLargeButtonTextStyle,)
        ),
      ),
    );
  }
}