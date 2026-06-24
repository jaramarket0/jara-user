import 'package:get/get.dart';
import 'package:jara_market/screens/add_money_screen/controller/add_money_controller.dart';

class AddMoneyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> AddMoneyController());
  }
}