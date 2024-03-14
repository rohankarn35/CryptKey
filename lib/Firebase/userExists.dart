import 'package:cloud_firestore/cloud_firestore.dart';

class UserExists {
  final firestoreInstance = FirebaseFirestore.instance;
  bool userExists = false;

  bool checkUserExistence(String uid) {
    firestoreInstance
        .collection('cryptkey')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      userExists = documentSnapshot.exists;
    });
    return userExists;
  }
}
