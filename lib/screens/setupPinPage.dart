import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/widgets/pinPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinPage extends StatefulWidget {
  final String heading;
  final String? pin;
  const PinPage({super.key, required this.pin, required this.heading});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  Future<bool> _validatePin(String pin) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var pinVal = prefs.getString("spin");
      if (pinVal == null) {
        pinVal = widget.pin;
        prefs.setString("spin", pin);
      }
      return pin == pinVal;
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Text(
              widget.pin == null
                  ? "Enter your Screen Pin"
                  : "Confirm your Screen pin",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            PinScreen(
              onValidatePin: widget.pin == null ? null : _validatePin,
              toNavigate: widget.pin == null
                  ? PinPage(
                      pin: "1234",
                      heading: "Confirm your Screen Pin",
                    )
                  : HomePage(),
              isSetup: widget.pin == null ? false : true,
            ),
          ],
        ),
      ),
    );
  }
}
