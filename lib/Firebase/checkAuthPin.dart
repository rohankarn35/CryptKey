import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckPin {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('cryptkey');

  Future<bool> checkPin(String pin) async {
    bool isPinCorrect = false;
    try {
      final userDocRef =
          _collectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
      // print(userDocRef.id);

      final userDocSnapshot = await userDocRef.get();

      print(FirebaseAuth.instance.currentUser!.uid);
      print(userDocSnapshot.data());

      final dynamic existingData = userDocSnapshot.data();
      final Map<String, dynamic> dataMap =
          existingData != null && existingData is Map
              ? Map<String, dynamic>.from(existingData)
              : {};

      final String encryptedCheckPinCorrect = dataMap['dummy']['test'];
      print(encryptedCheckPinCorrect);
      if ("cryptkey" ==
          DataEncryption().checkDecryption(pin, encryptedCheckPinCorrect)) {
        isPinCorrect = true;
      }

      return isPinCorrect;
    } catch (e) {
      return isPinCorrect;
    }
  }
}
