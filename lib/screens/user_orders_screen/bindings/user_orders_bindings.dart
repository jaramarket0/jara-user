import 'package:get/get.dart';
import 'package:jara_market/screens/user_orders_screen/controller/user_orders_controller.dart';

class UserOrdersBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> UserOrdersController());
  }
}