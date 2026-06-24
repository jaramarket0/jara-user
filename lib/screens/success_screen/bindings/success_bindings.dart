import 'package:get/get.dart';
import 'package:jara_market/screens/success_screen/controller/success_controller.dart';

class SuccessBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> SuccessController());
  }
}