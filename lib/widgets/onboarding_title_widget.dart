import 'package:flutter/material.dart';

class OnboardingTitle extends StatelessWidget {
  final String title;
  const OnboardingTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        fontFamily: 'Fellix-Bold',
      ),
    );
  }
}
