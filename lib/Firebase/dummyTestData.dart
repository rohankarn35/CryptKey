import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/dataEncryption.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DummyTestData {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> dummyData(bool doesExist) async {
    // Check if the user is already registered in Firestore

    if (doesExist) {
      print('User already exists in Firestore');
      return; // Exit the method
    }

    // If the user document doesn't exist, add dummy data
    final String data =await DataEncryption().encrypt("cryptkey");

    await _collectionReference.doc(FirebaseAuth.instance.currentUser!.uid).set({
      "dummy": {"test": data}
    });

    print('Dummy data added successfully');
  }
}
