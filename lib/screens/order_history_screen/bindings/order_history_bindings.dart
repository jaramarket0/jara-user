import 'package:get/get.dart';
import 'package:jara_market/screens/order_history_screen/controller/order_history_controller.dart';

class OrderHistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>OrderHistoryController());
  }
}