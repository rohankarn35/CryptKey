import 'package:local_auth/local_auth.dart';

class MobileAuth {
  static final _localAuth = LocalAuthentication();
  static Future<bool> canAuthenticate() async =>
      await _localAuth.canCheckBiometrics ||
      await _localAuth.isDeviceSupported();

  static Future<bool> authenticate(String reasonText) async {
    try {
      if (!await canAuthenticate()) {
        return false;
      }
      return await _localAuth.authenticate(
        localizedReason: reasonText,
        options: const AuthenticationOptions(
          sensitiveTransaction: true,
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
