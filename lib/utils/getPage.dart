import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getPage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString("page");
  return value;
}
