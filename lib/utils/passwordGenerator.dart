import 'dart:math';

class PasswordGenerator {
  static String generatePassword(int length) {
    const _lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const _uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const _numbers = '0123456789';
    const _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final _random = Random.secure();
    final _characters =
        _lowercaseLetters + _uppercaseLetters + _numbers + _symbols;

    String password = '';

    for (int i = 0; i < length; i++) {
      password += _characters[_random.nextInt(_characters.length)];
    }

    return password;
  }
}
