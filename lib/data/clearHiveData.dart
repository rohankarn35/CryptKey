import 'package:cryptkey/data/boxes.dart';

class ClearHiveData{
  static clearData(){
    final box = Boxes.getData();
    box.clear();
  }
}