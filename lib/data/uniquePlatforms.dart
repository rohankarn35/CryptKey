import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:flutter/foundation.dart';

class UniquePlatforms {
 List<String> uniquePlatforms() {
    final box = Boxes.getData();
    final List<String> platforms = [];
    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i) as PasswordManagerModel;
      if (!platforms.contains(data.platform) && data.platform != "Others") {
        platforms.add(data.platform);
      }
      if (data.platform == "Others") {
        platforms.add(data.platformName ?? ''); // Ensure platformName is not null
      }
    }
    return (platforms);
  }
}