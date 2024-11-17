import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      fontSize: 20,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
