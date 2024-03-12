import 'package:flutter/material.dart';

class CustomIcon {
  final List<String> items = [
    'facebook',
    'instagram',
    'x',
    'linkedin',
    'snapchat',
    'tiktok',
    'google',
    'bank',
    'others',
  ];
  Widget customIcon(String iconName, double size) {
    if (items.contains(iconName)) {
      return Image.asset(
        'assets/icons/$iconName.png',
        cacheHeight: size.toInt(),
        cacheWidth: size.toInt(),
      );
    } else {
      return Image.asset(
        'assets/icons/others.png',
        cacheHeight: size.toInt(),
        cacheWidth: size.toInt(),
      );
    }
  }
}
