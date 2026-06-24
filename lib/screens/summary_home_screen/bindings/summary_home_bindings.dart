import 'package:get/get.dart';
import 'package:jara_market/screens/summary_home_screen/controller/summary_home_controller.dart';

class SummaryHomeBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> SummaryHomeController());
  }
}