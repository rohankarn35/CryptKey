import 'dart:math';

class PasswordGenerator {
  static String generatePassword(int length) {
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final random = Random.secure();
    const characters =
        lowercaseLetters + uppercaseLetters + numbers + symbols;

    String password = '';

    for (int i = 0; i < length; i++) {
      password += characters[random.nextInt(characters.length)];
    }

    return password;
  }
}
