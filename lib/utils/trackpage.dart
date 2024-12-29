import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePageState(String pageName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("page", pageName);
}
