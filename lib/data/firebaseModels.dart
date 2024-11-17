class FirebaseModel {
  String id;
  String platform;
  String username;
  String password;
  String? platformName;
  bool isUploaded;

  FirebaseModel({
    required this.id,
    required this.platform,
    required this.username,
    required this.password,
    required this.platformName,
    this.isUploaded = false,
  });
}
