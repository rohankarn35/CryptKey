import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';

class platformData {
  getPlatformData(String platformName) {
    final box = Boxes.getData();
    for (int i = 0; i < box.length; i++) {
      final boxData = box.getAt(i);
      if (boxData!.platformName == platformName ||
          boxData.platform == platformName) {
        return i;
      }
    }
  }
}
