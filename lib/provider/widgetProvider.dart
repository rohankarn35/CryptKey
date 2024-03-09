import 'package:flutter/material.dart';

class WidgetProvider extends ChangeNotifier {
 int _sliderValue = 8;
  String? newPassword;

  int get sliderValue => _sliderValue;
  int setSliderValue(int value) {
    _sliderValue = value;
    notifyListeners();
    return sliderValue;
  }

  String? selectedValue;
   setSelectedValue(String value) {
    selectedValue = value;
    notifyListeners();
    return selectedValue;
  }
    updatePassword(String password){
    newPassword = password;
    notifyListeners();

  }
 
}
