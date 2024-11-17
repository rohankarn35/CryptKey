import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<PasswordManagerModel> getData() {
    return Hive.box<PasswordManagerModel>("cryptoKeyBox");
  }
}
