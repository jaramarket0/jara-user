import 'package:get/get.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';

class HomeBindings  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> HomeController());
  }
}