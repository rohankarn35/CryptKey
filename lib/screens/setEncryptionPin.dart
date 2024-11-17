import 'package:cryptkey/Firebase/dummyTestData.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/screens/setupPinPage.dart';
import 'package:cryptkey/widgets/pinPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Firebase/checkAuthPin.dart';

class SetEncryptionPin extends StatefulWidget {
  final bool doesExist;

  final String? heading;
  const SetEncryptionPin({super.key, required this.doesExist, this.heading});

  @override
  State<SetEncryptionPin> createState() => _SetEncryptionPinState();
}

class _SetEncryptionPinState extends State<SetEncryptionPin> {
  Future<bool> _onSubmit(String pin) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("pin", pin);
      if (!widget.doesExist) {
        await DummyTestData().dummyData(widget.doesExist);
        return true;
      }
      bool isPinCorrect = await CheckPin().checkPin(pin);
      return isPinCorrect;
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");

      return false;
    }
  }

  String? spin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScreenPin();
  }

  getScreenPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    spin = prefs.getString("spin");
    print("spin is $spin");
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
              widget.doesExist
                  ? "Enter your Encryption Pin"
                  : widget.heading == null
                      ? "Set your encryption pin"
                      : widget.heading ?? "Enter your Encryption Pin",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 50,
            ),
            PinScreen(
              onValidatePin: _onSubmit,
              toNavigate: spin != null
                  ? PinPage(pin: null, heading: "Set Screen Pin")
                  : HomePage(),
              isSetup: true,
            )
          ],
        ),
      ),
    );
  }
}
