import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/screenProvider.dart';

class EditHive {
  static Future<void> editHive(
      PasswordManagerModel data, int index, BuildContext context) async {
    final box = Boxes.getData();
    box.putAt(index, data);
    data.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("willBeUpdated", true);
    Provider.of<ScreenProvider>(context, listen: false).getAllFields(index);
  }
}
