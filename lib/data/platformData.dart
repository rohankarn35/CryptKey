import 'package:cryptkey/data/boxes.dart';

class platformData {
  getPlatformData(String platformName) {
    final box = Boxes.getData();
    List<int> platformsIndex = [];
    for (int i = 0; i < box.length; i++) {
      final boxData = box.getAt(i);
      if (boxData!.platformName == platformName ||
          boxData.platform == platformName) {
         platformsIndex.add(i);
      }
    }
    return platformsIndex;
  }
}
