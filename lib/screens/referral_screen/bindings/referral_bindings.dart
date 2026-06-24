import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_controller.dart';

class ReferralBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> ReferralController());
  }
}