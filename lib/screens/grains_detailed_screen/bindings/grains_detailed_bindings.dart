import 'package:get/get.dart';
import 'package:jara_market/screens/grains_detailed_screen/controller/grains_detailed_controller.dart';

class GrainsDetailedBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> GrainsDetailedController());
  }
}