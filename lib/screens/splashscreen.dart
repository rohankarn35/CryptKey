import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/screens/biometricPage.dart';
import 'package:cryptkey/screens/getStarted.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/screens/setEncryptionPin.dart';
import 'package:cryptkey/utils/getPage.dart';
import 'package:cryptkey/utils/navigation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    _animateText();
    _navigate();
  }

  _animateText() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 3), () async {
      String? page = await getPage();
      switch (page) {
        case "AuthenticationPage":
          navigateToPage(context, AuthenticationPage());
          break;
        case "SetEncryptionPin":
          navigateToPage(context, SetEncryptionPin());
          break;
        case "HomePage":
          navigateToPage(context, HomePage());
          break;
        case "BiometricPage":
          navigateToPage(context, BiometricPage());
          break;
        default:
          navigateToPage(context, GetStartedPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: AnimatedScale(
                scale: _scale,
                duration: Duration(seconds: 1),
                child: Image.asset(
                  "assets/icons/logo.png",
                  width: 100,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
