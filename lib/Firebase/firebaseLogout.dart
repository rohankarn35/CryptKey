import 'package:cryptkey/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseLogout {
  static Future<void> logout() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
      } else {}
    } catch (error) {
      ToastMessage.showToast("An error occured");
    }
  }
}
