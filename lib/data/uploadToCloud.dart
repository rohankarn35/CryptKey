import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/firebaseModels.dart';

class UploadToCloud {
  // Upload to Cloud
  Future<void> uploadToCloud() async {
    try {
      final box = Boxes.getData();
      for (var i = 0; i < box.length; i++) {
        final data = box.getAt(i);
        if (data != null) {
          final cloudData = FirebaseModel(
            id: i.toString(),
            platform: data.platform,
            username: data.username,
            password: data.password,
            platformName: data.platformName,
          );
          final encryptedCloudData =
              await DataEncryption().encryptData(cloudData);
          if (encryptedCloudData != null) {
            await CloudFirestoreService().addData(encryptedCloudData);
          }
          print("Data uploaded to cloud");
        }
      }
    } catch (e) {
      print("Error while uploading to cloud: $e");
    }
  }
}
