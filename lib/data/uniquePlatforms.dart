import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';

class UniquePlatforms {
  List<String> uniquePlatforms() {
    try {
      final box = Boxes.getData();
      final Set<String> uniquePlatformSet = {}; // Using a set to store unique names
      for (var i = 0; i < box.length; i++) {
        final data = box.getAt(i) as PasswordManagerModel;
        if (data.platform != "Others") {
          uniquePlatformSet.add(data.platform);
        }
        if (data.platform == "Others" && data.platformName != null) {
          uniquePlatformSet.add(data.platformName!.trim());
        }
      }
      // Convert the set to a list and return it
      return uniquePlatformSet.toList();
    } catch (e) {
      print("Error while getting unique platforms $e");
      return [];
    }
  }
}


