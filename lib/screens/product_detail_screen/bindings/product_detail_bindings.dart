import 'package:get/get.dart';
import 'package:jara_market/screens/product_detail_screen/controller/product_detail_controller.dart';

class ProductDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductDetailController());
  }
}