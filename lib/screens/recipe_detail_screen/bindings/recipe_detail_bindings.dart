import 'package:get/get.dart';
import 'package:jara_market/screens/recipe_detail_screen/controller/recipe_detail_controller.dart';

class RecipeDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> RecipeDetailController());
  }
}