import 'package:get/get.dart';
import 'package:jara_market/screens/category_screen/controller/category_controller.dart';

class CategoryBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> CategoryController());
  }
}