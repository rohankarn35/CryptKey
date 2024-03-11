import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadToCloud {
  // Upload to Hive
  uploadToCloud() async {
    try {
      final box = Boxes.getData();
      for (var i = 0; i < box.length; i++) {
        final data = box.getAt(i);
        final cloudData = FirebaseModel(
            id: i.toString(),
            platform: data!.platform,
            username: data.username,
            password: data.password,
            platformName: data.platformName);
        final encryptedCloudData = DataEncryption().encryptData(cloudData);
        await CloudFirestoreService().addData(encryptedCloudData);
        print("Data uploaded to cloud");
      }
    } catch (e) {
      print("Error whileuploading to cloud ${e}",);
    }
  }
}
