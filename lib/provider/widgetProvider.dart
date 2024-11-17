import 'package:flutter/material.dart';

class WidgetProvider extends ChangeNotifier {
 int _sliderValue = 8;
  String? newPassword;
 bool isPlatformNameVisible = false;
 TextEditingController controller = TextEditingController();

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
    controller.text = password;
    notifyListeners();

  }

  setPlatformNameVisible(bool value){
    isPlatformNameVisible = value;
    notifyListeners();

  }

  bool isPinCorrect = true;
  checkisPinCorrect(bool value){
    isPinCorrect = value;
    notifyListeners();
  }
 
}
