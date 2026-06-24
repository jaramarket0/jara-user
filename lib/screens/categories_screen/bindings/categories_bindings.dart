import 'package:get/get.dart';
import 'package:jara_market/screens/categories_screen/controller/categories_controller.dart';

class CategoriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> CategoriesController());
  }
}