import 'package:flutter/material.dart';
import 'package:gloou/screens/splash/splash.dart';
import 'package:gloou/shared/colors/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Fellix',
        primarySwatch: themeMainColor,
      ),
      home: SplashView(),
    );
  }
}
