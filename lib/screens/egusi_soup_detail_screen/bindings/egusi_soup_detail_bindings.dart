import 'package:get/get.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/controller/egusi_soup_detail_controller.dart';

class FoodDetailBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> FoodDetailController());
  }
}