import 'package:get/get.dart';
import 'package:jara_market/screens/orders_screen/controller/orders_controller.dart';

class OrdersBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
