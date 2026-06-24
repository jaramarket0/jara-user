import 'package:get/get.dart';
import 'package:jara_market/screens/forget_password_screen/controller/forget_password_controller.dart';

class ForgetPasswordBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>ForgetPasswordController());
  }
}