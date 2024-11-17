import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadToCloud {
  // Upload to Cloud
  Future<void> uploadToCloud() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isUpdating = prefs.getBool("willBeUpdated") ?? true;
      print("the data is updating $isUpdating");
      if (isUpdating) {
        final box = Boxes.getData();
        for (var i = 0; i < box.length; i++) {
          final data = box.getAt(i);
          if (data != null) {
            if (!data.isUploaded) {
              final cloudData = FirebaseModel(
                id: i.toString(),
                platform: data.platform,
                username: data.username,
                password: data.password,
                platformName: data.platformName,
                isUploaded: true,
              );
              final encryptedCloudData =
                  await DataEncryption().encryptData(cloudData);
              if (encryptedCloudData != null) {
                await CloudFirestoreService().addData(encryptedCloudData);
              }
            }
          }
        }
        prefs.setBool("willBeUpdated", false);
      }
    } catch (e) {
      print("Error while uploading to cloud: $e");
    }
  }
}
