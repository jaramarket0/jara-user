import 'package:get/get.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';

class ProfileBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> ProfileController());
  }
}