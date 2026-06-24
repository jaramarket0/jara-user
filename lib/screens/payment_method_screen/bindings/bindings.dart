import 'package:get/get.dart';
import 'package:jara_market/screens/payment_method_screen/controller/payment_method_controller.dart';

class PaymentMethodBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> PaymentMethodController());
  }
}