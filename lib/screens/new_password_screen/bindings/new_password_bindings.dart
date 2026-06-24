import 'package:get/get.dart';
import 'package:jara_market/screens/new_password_screen/controller/new_password_controller.dart';

class NewPasswordBindings extends Bindings {
@override
  void dependencies() {
    Get.lazyPut(()=> NewPasswordController());
  }
}