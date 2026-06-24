import 'package:get/get.dart';
import 'package:jara_market/screens/otp_verification/controller/otp_verification_controller.dart';

class OtpVerificationBindings extends Bindings {

@override
  void dependencies() {
    Get.lazyPut(()=> OtpVerificationController());
  }
}