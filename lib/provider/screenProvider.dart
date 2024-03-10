import 'package:cryptkey/data/boxes.dart';
import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool isVisible = false;

  String? platform;
  String? username;
  String? password;
  String? platformName;
  bool isLoading = false;


  updatePasswordVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }


  getAllFields(int index){
    final box = Boxes.getData();
    final data = box.getAt(index);
    platform = data!.platform;
    username = data.username;
    password = data.password;
    platformName = data.platformName;
    notifyListeners();
   
  }
  isLoadingAuth(bool isLoading){
    this.isLoading = isLoading;
    notifyListeners();

  }


}