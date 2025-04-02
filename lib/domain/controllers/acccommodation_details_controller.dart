import 'package:get/get.dart';

class DetailsController extends GetxController {
  var current = 0.obs;
  var currentImgList = <int>[].obs;

  void setCurrentImgList(int index, int value) {
    currentImgList[index] = value;
  }

  void setCurrent(int index) {
    current.value = index;
  }
}
