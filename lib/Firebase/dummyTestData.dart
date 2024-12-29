import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:cryptkey/utils/isGuestUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DummyTestData {
  Future<void> dummyData(bool doesExist) async {
    try {
      if (!isGuestUser()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Fluttertoast.showToast(msg: "User not logged in");
          return;
        }

        final CollectionReference _collectionReference =
            FirebaseFirestore.instance.collection('cryptkey');

        // // Logging for debugging
        // print("Checking for the 'cryptkey' collection and user document...");
        final secretData = user.uid;

        final String secret = secretData;
        final String data = await DataEncryption().encrypt(secret);

        if (doesExist) {
          print("Updating existing document for UID: ${user.uid}");
          await _collectionReference.doc(user.uid).set({
            "dummy": {"test": data}
          }, SetOptions(merge: true)); // Merge to update only this field
          print("Document updated successfully.");
          return;
        }

        print("Creating new document for UID: ${user.uid}");
        await _collectionReference.doc(user.uid).set({
          "dummy": {"test": data}
        });
        print("Document created successfully.");
      }
    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
      print("Error: $e\nStackTrace: $stackTrace");
    }
  }
}
