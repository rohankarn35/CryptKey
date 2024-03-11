import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('cryptkey');
  Future<void> addData(FirebaseModel data) async {
    try {
      ToastMessage.showToast("Uploading to Cloud... ");

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
      

      // Set the updated data back to the user's document
      await userDocRef.set(dataMap);

      ToastMessage.showToast("Data Uploaded to Cloud");
    } catch (e) {
      ToastMessage.showToast("An error occured");
    }
  }
}
