import 'package:get/get.dart';
import 'package:jara_market/screens/order_receipt_screen/controller/order_receipt_controller.dart';

class OrderReceiptBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> OrderReceiptController());
  }
}