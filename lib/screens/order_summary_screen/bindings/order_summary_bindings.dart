import 'package:get/get.dart';
import 'package:jara_market/screens/order_summary_screen/controller/order_summary_controller.dart';

class OrderSummaryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>OrderSummaryController());
  }
}