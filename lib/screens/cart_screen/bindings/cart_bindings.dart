import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';

class CartBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>CartController());
  }
}