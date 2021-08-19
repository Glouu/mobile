import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/screens/splash/first_time_splash.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SecureStorage secureStorage = SecureStorage();
  final TokenLogic tokenLogic = TokenLogic();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
      Duration(milliseconds: 1500),
      () => {init()},
    );
  }

  init() async {
    var isLoggedIn = await tokenLogic.isTokenValid();
    var isUsingPlatform = await secureStorage.readSecureData('isUsingPlatform');
    if (isUsingPlatform == 'true') {
      isLoggedIn
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeneralHome()),
            )
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LogIn()),
              (router) => false,
            );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstTimeSplash(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/logo.svg'),
          ],
        ),
      ),
    );
  }
}
