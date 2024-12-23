import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  var isPermitted = false.obs;

  onChange(RxInt value) {
    index.value = value.value;
    update();
  }
}

class HomeScreenController extends GetxController {
  RxInt index = 0.obs;

  indexChange(RxInt value) {
    index.value = value.value;
    update();
  }
}
