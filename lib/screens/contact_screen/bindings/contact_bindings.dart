import 'package:get/get.dart';
import 'package:jara_market/screens/contact_screen/controller/contact_controller.dart';

class ContactBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> ContactController());
  }
}