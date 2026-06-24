import 'package:get/get.dart';
import 'package:jara_market/screens/grains_screen/controller/grains_controller.dart';

class GrainsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> GrainsController());
  }
}