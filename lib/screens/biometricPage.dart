import 'package:cryptkey/screens/setupPinPage.dart';
import 'package:cryptkey/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/mobileAuth.dart';
import '../utils/toastMessage.dart';

class BiometricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " Setup your biometrics",
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            SizedBox(height: 100.0),
            GestureDetector(
              onTap: () => _onTapped(context),
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900], // Dark gray for background
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      blurRadius: 30.0,
                      spreadRadius: 15.0,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey[800]!,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fingerprint,
                    size: 120.0, // Slightly smaller for balance
                    color: Colors.white, // White for fingerprint icon
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTapped(BuildContext context) async {
    // Produce a vibration effect
    HapticFeedback.vibrate();

    if (await MobileAuth.canAuthenticate()) {
      if (await MobileAuth.authenticate("Setup your biometrics")) {
        navigateToPage(
            context,
            PinPage(
              pin: null,
              heading: "Set your Screen pin",
            ));
      } else {
        ToastMessage.showToast("Unable to authenticate");
      }
    }
    HapticFeedback.vibrate();
  }
}
