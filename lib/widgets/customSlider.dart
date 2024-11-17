import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/utils/passwordGenerator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSlider {
  static Widget customSlider(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        valueIndicatorColor: Colors.white.withOpacity(0.3),
        inactiveTrackColor: Colors.black,
        activeTrackColor: Colors.white,
        thumbColor: Colors.white,
      ),
      child: Consumer<WidgetProvider>(
          builder: (context, WidgetProvider provider, child) {
        return Slider(
          value: provider.sliderValue.toDouble(),
          min: 8,
          max: 20,
          divisions: 12,
          label: provider.sliderValue.toString(),
          onChanged: (double value) {
            provider.setSliderValue(value.toInt());
            Provider.of<WidgetProvider>(context, listen: false).updatePassword(
                PasswordGenerator.generatePassword(value.toInt()));
          },
        );
      }),
    );
  }
}
