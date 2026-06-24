import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_address_change/controller/checkout_address_change_controller.dart';

class CheckoutAddressChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutAddressChangeController());
  }
}