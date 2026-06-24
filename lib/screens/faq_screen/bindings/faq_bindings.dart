import 'package:get/get.dart';
import 'package:jara_market/screens/faq_screen/controller/faq_controller.dart';

class FaqBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> FaqController());
  }
}