import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/new_password_screen/new_password_screen.dart';
import 'package:jara_market/services/api_service.dart';

class OtpVerificationController extends GetxController {
ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;
  RxBool showCountdown = false.obs;
TextEditingController otpController = TextEditingController();


  void startCountdown() {
    Future.delayed(const Duration(seconds: 2), () {
      
        showCountdown.value = true;
      
    });
  }



  Future<void> validateOtp(Map<String,dynamic> otpData) async {
    print(otpData);
      isLoading.value = true;


    try {
      // Non-consuming check: confirms the OTP is valid without burning it,
      // since the actual reset-password step still needs to validate (and
      // consume) it for real -- calling /validate-otp here would delete it
      // early and make the reset-password step always fail afterwards.
      final response = await apiService.checkOtp(otpData);


        isLoading.value = false;


      if (response.statusCode == 200 || response.statusCode == 201) {
        final otp = otpData['otp'];
        otpController.dispose();
        Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(builder: (context) =>  NewPasswordScreen(email: otpData['email'], otp: otp,)),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('OTP validation failed: ${response.body}')),
        );
      }
    } catch (e) {
      
        isLoading.value = false;
      
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> resendOtp(Map<String,dynamic> resendData) async {
    try {
      // 

      // You might need to implement a resend OTP endpoint in your API service
      // For now, we'll use the login endpoint to trigger a new OTP
      final response = await apiService.resendOtp(resendData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('A new code has been sent to your email.')),
        );
        startCountdown();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to resend code: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

}