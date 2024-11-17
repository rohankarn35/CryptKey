import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadToHive {
  // Upload data to hive
  Future<void> uploadDataToHive() async {
    try {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('cryptkey');
      final userDocRef =
          collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await userDocRef.get();

      final dynamic existingData = userDocSnapshot.data();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (existingData != null) {
        final Map<String, dynamic> dataMap =
            existingData != null && existingData is Map
                ? Map<String, dynamic>.from(existingData)
                : {};

        if (dataMap.isEmpty ||
            (dataMap.length == 1 && dataMap.containsKey('dummy'))) {
          return;
        }

        await Future.forEach(dataMap.entries, (entry) async {
          if (entry.key == 'dummy') return;

          final String platform =
              await DataEncryption().decrypt(entry.value['platform']);
          final String username =
              await DataEncryption().decrypt(entry.value['username']);
          final String password =
              await DataEncryption().decrypt(entry.value['password']);

          String? platformName = entry.value['platformName'] != null &&
                  entry.value['platformName'].toString().isNotEmpty &&
                  entry.value['platformName'].toString().length > 1
              ? await DataEncryption().decrypt(entry.value['platformName'])
              : null;

          final paswordManagerModelData = PasswordManagerModel(
            platform: platform,
            username: username,
            password: password,
            platformName: platformName,
            isUploaded: true,
          );
          final box = Boxes.getData();
          // Check if the data already exists

          // Add data only if it doesn't already exist
          bool isDuplicate = false;
          for (var i = 0; i < box.length; i++) {
            if (box.getAt(i)!.platform == platform &&
                box.getAt(i)!.username == username) {
              isDuplicate = true;
              break;
            }
          }
          if (!isDuplicate) {
            box.add(paswordManagerModelData);
            paswordManagerModelData.save();
          }
        });

        prefs.setBool('isFirst', false);
        prefs.setBool("willBeUpdated", false);

        ToastMessage.showToast("Data Updated");
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    } catch (e) {
      ToastMessage.showToast("Error uploading data to hive");
    }
  }
}
