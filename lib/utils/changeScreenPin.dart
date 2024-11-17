import 'package:shared_preferences/shared_preferences.dart';

class Changescreenpin {
  Future<bool> changeScreenPin(String newPin) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("spin", newPin);
      return true;
    } catch (e) {
      return false;
    }
  }
}
