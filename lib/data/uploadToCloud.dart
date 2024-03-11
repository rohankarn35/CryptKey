import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/firebaseModels.dart';

class UploadToCloud {
  // Upload to Hive
  uploadToCloud() async {
  try {
      final box = Boxes.getData();
    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      final cloudData = FirebaseModel(
          id: i.toString(),
          platform: data!.platform,
          username: data.username,
          password: data.password,
          platformName: data.platformName);
      await CloudFirestoreService().addData(cloudData);
    }
    
  } catch (e) {
    print(e);
    
  }
  }
}
