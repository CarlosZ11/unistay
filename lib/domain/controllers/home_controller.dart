import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentImgList = <int>[].obs;

  void setCurrentImgList(int index, int value) {
    currentImgList[index] = value;
  }
}
