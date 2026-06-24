import 'package:get/get.dart';
import 'package:jara_market/screens/main_screen/controller/main_controller.dart';

class MainBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> MainController());
  }
}