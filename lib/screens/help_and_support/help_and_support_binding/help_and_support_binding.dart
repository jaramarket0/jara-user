import 'package:get/get.dart';
import 'package:jara_market/screens/help_and_support/help_and_support_controller/help_and_support_controller.dart';

class HelpAndSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpAndSupportController>(
      () => HelpAndSupportController(),
    );
  }
}