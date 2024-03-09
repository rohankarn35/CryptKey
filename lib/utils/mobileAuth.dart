import 'package:local_auth/local_auth.dart';

class MobileAuth {
  static final _localAuth = LocalAuthentication();
  static Future<bool> _canAuthenticate() async =>
      await _localAuth.canCheckBiometrics ||
      await _localAuth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
     
      if (!await _canAuthenticate()) {
        return false;
      }
      return await _localAuth.authenticate(
        localizedReason: "Authenticate to view your passwords.",
        options: const AuthenticationOptions(
          sensitiveTransaction: true,
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}
