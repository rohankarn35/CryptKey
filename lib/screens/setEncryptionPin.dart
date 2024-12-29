import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/widgets/pinPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/trackpage.dart';

class SetEncryptionPin extends StatefulWidget {
  const SetEncryptionPin({
    super.key,
  });

  @override
  State<SetEncryptionPin> createState() => _SetEncryptionPinState();
}

class _SetEncryptionPinState extends State<SetEncryptionPin> {
  late Future<bool> _doesUserExistFuture;

  @override
  void initState() {
    super.initState();
    _doesUserExistFuture = _doesUserExist();
    savePageState("SetEncryptionPin");
  }

  Future<bool> _doesUserExist() async {
    try {
      return await CloudFirestoreService().isUserInDatabase();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error checking user existence: $e");
      return false;
    }
  }

  // Future<bool> _onSubmit(String pin, bool doesExist) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("pin", pin);
  //     if (doesExist) {
  //       await DummyTestData().dummyData(doesExist);
  //       return true;
  //     }
  //     bool isPinCorrect = await CheckPin().checkPin(pin);
  //     return isPinCorrect;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _doesUserExistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final doesExist = snapshot.data ?? false;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Text(
                      doesExist
                          ? "Enter your Encryption Pin"
                          : "Set your encryption pin",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    PinScreen(
                      doesExist: doesExist,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
