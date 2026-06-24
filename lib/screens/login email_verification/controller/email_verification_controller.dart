
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/services/api_service.dart';

ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
class LoginEmailVerificationController extends GetxController {
RxBool _showCountdown = false.obs;
RxBool isLoading = false.obs;

  bool get showCountdown => _showCountdown.value;
  set showCountdown(bool value) => _showCountdown.value = value;

  final TextEditingController otpController = TextEditingController();
  bool _isVerifying = false;
  bool get isVerifying => _isVerifying;
  set isVerifying(bool value) => _isVerifying = value;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
    _stopCountdown();
  }

 void _startCountdown() {
    Future.delayed(const Duration(seconds: 2), () {
      showCountdown = true;
    })
    ;
  }

   void _stopCountdown() {
    Future.delayed(const Duration(minutes: 4), () {
      showCountdown = false;
    })
    ;
  }

Future<void> resendOtp(Map<String, String> resendData) async {
    try {
      // final resendData = {
      //   'email': widget.email,
      // };

      // You might need to implement a resend OTP endpoint in your API service
      // For now, we'll reuse the registration endpoint
      final response = await _apiService.resendOtp(resendData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('A new code has been sent to your email')),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to resend code: ${response.body}["message"]')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  Future<void> verifyOtp(Map<String, String> otpData) async {
  myLog.log('Verifying OTP: ${otpData['otp']}');
      isLoading.value = true;
  

    try {
      // final otpData = {
      //   'email': widget.email,
      //   'otp': _otpController.text,
      // };

      final response = await _apiService.validateUserLoginOtp(otpData);

      
        isLoading.value = false;
      

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigator.pushReplacement(
        //   Get.context!,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
        Get.offAllNamed('/main_screen');
      } else {
        var  responseBody = jsonDecode(response.body);
        var message = responseBody['message'] ?? 'something went wrong';
        
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('OTP verification failed: ${message}')),
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