import 'package:flutter/material.dart';

class WidgetProvider extends ChangeNotifier {
 int _sliderValue = 8;
  String? newPassword;
 bool isPlatformNameVisible = false;

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
   
  }
    updatePassword(String password){
    newPassword = password;
    notifyListeners();

  }

  setPlatformNameVisible(bool value){
    isPlatformNameVisible = value;
    notifyListeners();

  }
 
}
