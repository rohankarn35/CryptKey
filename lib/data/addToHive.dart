import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDataToHive {
  static Future<bool> addData(String platformName, String platform,
      String userName, String password) async {
    final data = PasswordManagerModel(
      platform: platform,
      username: userName,
      password: password,
      platformName: platformName,
    );
    final box = Boxes.getData();
    // Check if the data already exists

    // Add data only if it doesn't already exist
    bool isDuplicate = false;
    for (var i = 0; i < box.length; i++) {
      if (box.getAt(i)!.platform == platform &&
          box.getAt(i)!.username == userName) {
        isDuplicate = true;
        break;
      }
    }
    if (!isDuplicate) {
      // ToastMessage.showToast("Account added");
      box.add(data);
      data.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("willBeUpdated", true);
      return true;
    } else {
      ToastMessage.showToast("Account already exists");
      return false;
    }
  }
}
