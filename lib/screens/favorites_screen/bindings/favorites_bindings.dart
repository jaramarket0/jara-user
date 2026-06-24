import 'package:get/get.dart';
import 'package:jara_market/screens/favorites_screen/controller/favorites_controller.dart';

class FavoritesBindings extends Bindings {
@override
  void dependencies() {
    Get.lazyPut(()=> FavoritesController());
  }
}