import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('cryptkey');
  Future<void> addData(FirebaseModel data) async {
    try {
      final userDocRef =
          _collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);

      final userDocSnapshot = await userDocRef.get();

      final dynamic existingData = userDocSnapshot.data();
      final Map<String, dynamic> dataMap =
          existingData != null && existingData is Map
              ? Map<String, dynamic>.from(existingData)
              : {};

      dataMap[data.id] = {
        'platform': data.platform,
        'username': data.username,
        'password': data.password,
        'platformName': data.platformName,
      };

      await userDocRef.set(dataMap);
    } catch (e) {
      ToastMessage.showToast("An error occured");
    }
  }

  clearData() async {
    try {
      final userDocRef =
          _collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
      await userDocRef.delete();
    } catch (e) {
      ToastMessage.showToast("An error occured");
    }
  }
}
