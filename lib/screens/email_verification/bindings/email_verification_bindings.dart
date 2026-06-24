import 'package:get/get.dart';
import 'package:jara_market/screens/email_verification/controller/email_verification_controller.dart';

class EmailVerificationBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> EmailVerificationController());
  }
}