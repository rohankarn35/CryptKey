import 'package:shared_preferences/shared_preferences.dart';

class ClearSharedData {
  clearSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isFirst");
    prefs.remove("pin");
    prefs.remove("hasUploadedData");
  }
}
