import 'package:flutter/material.dart';

void navigateToPage(BuildContext context, Widget page) {
  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => page,
    ),
    (_) => false,
  );
}
