import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/utils/isGuestUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DummyTestData {
  Future<void> dummyData(bool doesExist) async {
    try {
      if (!isGuestUser()) {
        final CollectionReference _collectionReference =
            FirebaseFirestore.instance.collection('cryptkey');
        // Check if the user is already registered in Firestore
        final String data = await DataEncryption().encrypt("cryptkey");
        if (doesExist) {
          await _collectionReference
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"dummy.test": data});
          return; // Exit the method
        }

        // If the user document doesn't exist, add dummy data

        await _collectionReference
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "dummy": {"test": data}
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      rethrow;
    }
  }
}
