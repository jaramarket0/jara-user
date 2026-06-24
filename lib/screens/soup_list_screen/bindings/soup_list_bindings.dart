import 'package:get/get.dart';
import 'package:jara_market/screens/soup_list_screen/controller/soup_list_controller.dart';

class SoupListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> SoupListController());
  }
}