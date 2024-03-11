import 'dart:typed_data';

import 'package:cryptkey/data/firebaseModels.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataEncryption {
  encrypt(String data) {
    try {
      final String plainText = data;
      int count = 1234;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String email = FirebaseAuth.instance.currentUser!.email!;
      String uidstring = uid.substring(0, 20);
      String secretkey = uidstring + count.toString() + email.substring(0, 8);

      final key = Key.fromUtf8(secretkey);
      final iv = IV(Uint8List.fromList(List.generate(16, (index) => 0)));

      final encrypter = Encrypter(AES(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      return encrypted.base64;
    } catch (e) {
      print("error while encrypting data ${e}");
    }
  }

  encryptData(FirebaseModel data) {
    try {
      String encryptedPlatform = encrypt(data.platform);
      String encryptedUsername = encrypt(data.username);
      String encryptedPassword = encrypt(data.password);
      String? encryptedPlatformName;
      if (data.platformName!.isNotEmpty) {
        encryptedPlatformName = encrypt(data.platformName!);
      }

      return FirebaseModel(
          id: data.id,
          platform: encryptedPlatform,
          username: encryptedUsername,
          password: encryptedPassword,
          platformName: encryptedPlatformName);
    } catch (e) {
      print("errpr while encrypting data ${e}");
    }
  }

  decrypt(String data) {
    final plainText = data;
    int count = 1234;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String email = FirebaseAuth.instance.currentUser!.email!;
    String uidstring = uid.substring(0, 20);
    String secretkey = uidstring + count.toString() + email.substring(0, 8);

    final key = Key.fromUtf8(secretkey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
