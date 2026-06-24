import 'package:get/get.dart';
import 'package:jara_market/screens/order_tracking_screen/controller/order_tracking_controller.dart';

class OrderTrackingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> OrderTrackingController());
  }
}