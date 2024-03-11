import 'package:cryptkey/data/boxes.dart';
import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool isVisible = false;

  String? platform;
  String? username;
  String? password;
  String? platformName;
  bool isLoading = false;
  int count = 0;

  updatePasswordVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  getAllFields(int index) {
    final box = Boxes.getData();
    final data = box.getAt(index);
    platform = data!.platform;
    username = data.username;
    password = data.password;
    platformName = data.platformName;
    notifyListeners();
  }

  isLoadingAuth(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  List<String> _platformsList = [];

  List<String> get platformsList => _platformsList;

  void setPlatforms(List<String> platformsList) {
    _platformsList = platformsList;
    notifyListeners();
  }

  void numberOfAccounts(String platform) {
    final box = Boxes.getData();
    count = 0;
    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data!.platform == platform) {
        count++;
      } else if (data.platformName == platform) {
        count++;
      }
    }
    notifyListeners();
  }
}
