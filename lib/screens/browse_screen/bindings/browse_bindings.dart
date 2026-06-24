import 'package:get/get.dart';
import 'package:jara_market/screens/browse_screen/controller/browse_controller.dart';

class BrowseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> BrowseController());
  }
}