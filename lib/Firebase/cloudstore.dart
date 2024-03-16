import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('cryptkey');
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> addData(FirebaseModel data) async {
    try {
      final userDocRef =
          _collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);

      final userDocSnapshot = await userDocRef.get();

      final Map<String, dynamic> dataMap =
          userDocSnapshot.data() as Map<String, dynamic>? ?? {};

      dataMap[data.id] = {
        'platform': data.platform,
        'username': data.username,
        'password': data.password,
        'platformName': data.platformName,
      };

      await userDocRef.set(dataMap);
    } catch (e) {
      print("Error while adding data: $e");
      ToastMessage.showToast("An error occurred");
    }
  }

  Future<void> clearData() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentReference userDocRef = _collectionReference.doc(uid);

      final Map<String, dynamic> dataMap = {};

      // Clear all fields in the document

      await userDocRef.set(dataMap);
      final String data = await DataEncryption().encrypt("cryptkey");

      await _collectionReference
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "dummy": {"test": data}
      });
    } catch (e) {
      print("Error while clearing data: $e");
      ToastMessage.showToast("An error occurred");
    }
  }

  Future<bool> checkAndAddUser() async {
    try {
      final userDocRef = _userCollectionRef.doc('usersList');

      final userDocSnapshot = await userDocRef.get();

      final Map<String, dynamic> dataMap =
          userDocSnapshot.data() as Map<String, dynamic>? ?? {};

      if (dataMap.containsKey(FirebaseAuth.instance.currentUser!.uid)) {
        return true;
      } else {
        dataMap[FirebaseAuth.instance.currentUser!.uid] = {
          'email': FirebaseAuth.instance.currentUser!.email,
        };

        await userDocRef.set(dataMap);
        return false;
      }
    } catch (e) {
      print("Error while checking and adding user: $e");
      ToastMessage.showToast("An error occurred");
      return false;
    }
  }

  Future<void> updateWhileInternetConnection() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentReference userDocRef = _collectionReference.doc(uid);

    final Map<String, dynamic> dataMap = {};

    // Clear all fields in the document

    await userDocRef.set(dataMap);
    UploadToCloud().uploadToCloud();
    final String data = await DataEncryption().encrypt("cryptkey");

    await _collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "dummy": {"test": data}
    });
  }
}
