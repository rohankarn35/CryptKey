import 'package:flutter/material.dart';

class CustomIcon {
  Widget customIcon(String iconName, double size) {
    return Image.asset(
      'assets/icons/$iconName.png',
   
      cacheHeight: size.toInt(),
      cacheWidth: size.toInt(),
    );
  }
}
