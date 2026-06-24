import 'package:get/get.dart';
import 'package:jara_market/screens/login%20email_verification/controller/email_verification_controller.dart';

class LoginEmailVerificationBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> LoginEmailVerificationController());
  }
}