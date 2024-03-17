import 'dart:math';

class PasswordGenerator {
  static String generatePassword(int length) {
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final random = Random.secure();

    // Ensure at least one of each character type
    String password = '';
    password += lowercaseLetters[random.nextInt(lowercaseLetters.length)];
    password += uppercaseLetters[random.nextInt(uppercaseLetters.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += symbols[random.nextInt(symbols.length)];

    // Fill remaining characters randomly
    const characters = lowercaseLetters + uppercaseLetters + numbers + symbols;
    for (int i = 4; i < length; i++) {
      password += characters[random.nextInt(characters.length)];
    }

    // Convert the password string to a list of characters
    List<String> passwordList = password.split('');

    // Shuffle the password characters to increase randomness
    passwordList.shuffle(random);

    // Convert the shuffled list back to a string
    password = passwordList.join();

    return password;
  }
}
