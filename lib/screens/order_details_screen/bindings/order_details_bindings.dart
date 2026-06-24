import 'package:get/get.dart';
import 'package:jara_market/screens/order_details_screen/controller/order_details_controller.dart';

class OrderDetailsBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> OrderDetailsController());
  }
}