import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloou/screens/welcome/welcome.dart';
import 'package:gloou/shared/colors/colors.dart';

class FirstTimeSplash extends StatefulWidget {
  const FirstTimeSplash({Key? key}) : super(key: key);

  @override
  _FirstTimeSplashState createState() => _FirstTimeSplashState();
}

class _FirstTimeSplashState extends State<FirstTimeSplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
      Duration(milliseconds: 2000),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Welcome(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SvgPicture.asset('assets/images/full_logo.svg')],
        ),
      ),
    );
  }
}
