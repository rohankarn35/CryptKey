import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/utils/navigation.dart';
import 'package:cryptkey/utils/trackpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/mobileAuth.dart';
import '../utils/toastMessage.dart';

class BiometricPage extends StatefulWidget {
  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  late Future<bool> doesMobileHaveAuth;

  @override
  void initState() {
    super.initState();
    doesMobileHaveAuth = MobileAuth.canAuthenticate();
    savePageState("BiometricPage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<bool>(
        future: doesMobileHaveAuth,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == false) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80.0,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Screen lock is not set up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Please enable it in your settings to continue.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Confirm your screen lock",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
                GestureDetector(
                  onTap: () => _onTapped(context),
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 14, 38, 80),
                          const Color.fromARGB(255, 4, 56, 80)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 30.0,
                          spreadRadius: 10.0,
                          offset: Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fingerprint,
                        size: 100.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _onTapped(BuildContext context) async {
    // Produce a vibration effect
    HapticFeedback.vibrate();

    if (await MobileAuth.canAuthenticate()) {
      if (await MobileAuth.authenticate("Confirm your screen lock")) {
        // Uncomment and implement navigation when ready
        navigateToPage(context, HomePage());
      } else {
        ToastMessage.showToast("Unable to authenticate");
      }
    }
    HapticFeedback.vibrate();
  }
}
