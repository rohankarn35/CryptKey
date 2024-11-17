import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/uniquePlatforms.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenProvider extends ChangeNotifier {
  String? platform;
  String? username;
  String? password;
  String? platformName;
  bool isLoading = false;
  int count = 0;
  List<bool> isVisible = [];

  updatePasswordVisibility(List<bool> isVisibleList, int index) {
    isVisible = isVisibleList;

    isVisible[index] = !isVisible[index];

    notifyListeners();
    return isVisible;
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
  String? _screenPin;
  String? get screenpin => _screenPin;
  String? _encryptionPin;
  String? get encryptionpin => _encryptionPin;

  void setPlatforms() {
    final List<String> platformsLists = UniquePlatforms().uniquePlatforms();
    _platformsList = platformsLists;
    notifyListeners();
  }

  void emptyData() {
    _platformsList.clear();

    notifyListeners();
  }

  void setPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getpin = prefs.getString("spin");
    String? encPin = prefs.getString("pin");
    _screenPin = getpin;
    _encryptionPin = encPin;
  }

  int numberOfAccounts(String platform) {
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

    return count;
  }

  updateui() {
    notifyListeners();
  }
}
