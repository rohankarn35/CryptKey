import 'package:firebase_auth/firebase_auth.dart';

bool isGuestUser() {
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    return true;
  }
  return false;
}
