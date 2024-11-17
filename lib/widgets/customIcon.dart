import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    'github',
    'others',
  ];
  Widget customIcon(String iconName, double size) {
    if (items.contains(iconName)) {
      return SvgPicture.asset(
        "assets/icons/$iconName.svg",
        color: Colors.black,
        width: size,
        height: size,
      );
    } else {
      return SvgPicture.asset(
        "assets/icons/others.svg",
        width: size,
        height: size,
      );
    }
  }
}
