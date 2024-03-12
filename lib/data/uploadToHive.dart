import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadToHive {
  // Upload data to hive
  void uploadDataToHive() async {
    try {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('cryptkey');

      final userDocRef =
          collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await userDocRef.get();

      final dynamic existingData = userDocSnapshot.data();
      if (existingData == null) {
        return;
      }
      final Map<String, dynamic> dataMap =
          Map<String, dynamic>.from(existingData);
      dataMap.forEach((key, value) {
        final String platform = DataEncryption().decrypt(value['platform']);
        final String username = DataEncryption().decrypt(value['username']);
        final String password = DataEncryption().decrypt(value['password']);

        String? platformName;

        if (value['platformName'] != null &&
            value['platformName'].toString().isNotEmpty) {
          platformName = DataEncryption().decrypt(value['platformName']);
        }

        final paswordManagerModelData = PasswordManagerModel(
            platform: platform,
            username: username,
            password: password,
            platformName: platformName);
        final box = Boxes.getData();
        box.add(paswordManagerModelData);
        paswordManagerModelData.save();
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isFirst', false);
      ToastMessage.showToast("Data Updated");
    } catch (e) {
      print("error while uploading to hive $e");
    }
  }
}
