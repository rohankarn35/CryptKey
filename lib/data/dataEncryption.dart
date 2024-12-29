import 'dart:typed_data';

import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/secrets/secretDatatoencrypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEncryption {
  final secretData = FirebaseAuth.instance.currentUser!.uid;
  Future<String> encrypt(String data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String pin = prefs.getString('pin')!;

      final String plainText = data;
      String email = secretNumber;
      String uidstring = secretData.substring(0, 20);
      String secretkey = uidstring + pin + email.substring(0, 8);

      final key = Key.fromUtf8(secretkey);
      final iv = IV(Uint8List.fromList(List.generate(16, (index) => 0)));

      final encrypter = Encrypter(AES(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      return encrypted.base64;
    } catch (e) {
      rethrow;
    }
  }

  Future<FirebaseModel?> encryptData(FirebaseModel data) async {
    try {
      String encryptedPlatform = await encrypt(data.platform);
      String encryptedUsername = await encrypt(data.username);
      String encryptedPassword = await encrypt(data.password);
      String? encryptedPlatformName;
      if (data.platformName != null && data.platformName!.isNotEmpty) {
        encryptedPlatformName = await encrypt(data.platformName!);
      }

      return FirebaseModel(
        id: data.id,
        platform: encryptedPlatform,
        username: encryptedUsername,
        password: encryptedPassword,
        platformName: encryptedPlatformName,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String> decrypt(String? data) async {
    if (data == null) return '';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String pin = prefs.getString('pin')!;
      String email = secretNumber;
      String uidstring = secretData.substring(0, 20);
      String secretkey = uidstring + pin + email.substring(0, 8);

      final key = Key.fromUtf8(secretkey);
      final iv = IV(Uint8List.fromList(List.generate(16, (index) => 0)));

      final encrypter = Encrypter(AES(key));

      final decrypted = encrypter.decrypt64(data, iv: iv);

      return decrypted;
    } catch (e) {
      rethrow;
    }
  }

  String checkDecryption(String pin, String data) {
    try {
      String email = secretNumber;
      String uidstring = secretData.substring(0, 20);
      String secretkey = uidstring + pin + email.substring(0, 8);

      final key = Key.fromUtf8(secretkey);
      final iv = IV(Uint8List.fromList(List.generate(16, (index) => 0)));

      final encrypter = Encrypter(AES(key));

      final decrypted = encrypter.decrypt64(data, iv: iv);
      print("the descrypted is $decrypted");

      return decrypted;
    } catch (e) {
      rethrow;
    }
  }
}
