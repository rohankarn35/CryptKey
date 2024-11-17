import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/Firebase/checkAuthPin.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/Firebase/dummyTestData.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dataEncryption.dart';

class ChangeEncPin {
  Future<bool> changeEncPin(String oldPin, String newPin) async {
    try {
      List<PasswordManagerModel> passwordManagerList = [];
      final collectionReference =
          FirebaseFirestore.instance.collection('cryptkey');
      final userDocRef =
          collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await userDocRef.get();

      final existingData = userDocSnapshot.data();

      if (existingData == null || existingData.isEmpty) {
        return false;
      }

      for (var entry in existingData.entries) {
        if (entry.key == 'dummy') continue;

        final platform =
            await DataEncryption().decrypt(entry.value['platform']);
        final username =
            await DataEncryption().decrypt(entry.value['username']);
        final password =
            await DataEncryption().decrypt(entry.value['password']);
        final platformName = entry.value['platformName'] != null &&
                entry.value['platformName'].toString().isNotEmpty
            ? await DataEncryption().decrypt(entry.value['platformName'])
            : null;

        passwordManagerList.add(PasswordManagerModel(
          platform: platform,
          username: username,
          password: password,
          platformName: platformName,
          isUploaded: true,
        ));
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("pin", newPin);

      for (int i = 0; i < passwordManagerList.length; i++) {
        var pass = passwordManagerList[i];
        final cloudData = FirebaseModel(
          id: i.toString(),
          platform: pass.platform,
          username: pass.username,
          password: pass.password,
          platformName: pass.platformName,
          isUploaded: true,
        );

        final encryptedCloudData =
            await DataEncryption().encryptData(cloudData);
        if (encryptedCloudData != null) {
          await CloudFirestoreService().addData(encryptedCloudData);
        }
      }
      await DummyTestData().dummyData(true);
      bool isConnected = await CheckPin().checkPin(newPin);
      if (!isConnected) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("pin", oldPin);
      }
      return isConnected;
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("pin", oldPin);
      ToastMessage.showToast("Cannot Change Encryption Pin");
      return false;
    }
  }
}
