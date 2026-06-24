import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/otp_verification/otp_verification.dart';
import 'package:jara_market/services/api_service.dart';

class ForgetPasswordController extends GetxController {
ApiService apiService = ApiService(Duration(seconds: 60 * 5));
RxBool isLoading = false.obs;
TextEditingController emailController = TextEditingController();

Future<void> requestPasswordReset() async {
    
      isLoading.value = true;
    

    try {
      final resetData = {
        'email': emailController.text,
        //'reset_password': true, // Flag to indicate password reset request
      };

      // Use login endpoint to trigger password reset flow
      final response = await apiService.forgotPassword(resetData);

      
        isLoading.value = false;
      

      if (response.statusCode == 200 || response.statusCode == 201) {
        emailController.dispose();
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(email: emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Password reset request failed: ${response.body}')),
        );
      }
    } catch (e) {
      
        isLoading.value = false;
      
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
}