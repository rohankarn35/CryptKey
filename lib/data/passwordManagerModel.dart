// ignore: file_names

import 'package:hive/hive.dart';
part 'passwordManagerModel.g.dart';

@HiveType(typeId: 0)
class PasswordManagerModel extends HiveObject {
  @HiveField(0)
  String platform;
  @HiveField(1)
  String username;
  @HiveField(2)
  String password;
  @HiveField(3)
  String? platformName;
  @HiveField(4)
  bool isUploaded;
  PasswordManagerModel({
    required this.platform,
    required this.username,
    required this.password,
    required this.platformName,
    this.isUploaded = false,
  });
}
