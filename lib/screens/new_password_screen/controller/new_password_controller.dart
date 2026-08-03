import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/login_screen/login_screen.dart';
import 'package:jara_market/services/api_service.dart';

class NewPasswordController extends GetxController {
ApiService apiService = ApiService(Duration(seconds:60 * 5))  ;
  RxBool isLoading = false.obs;
TextEditingController passwordController = TextEditingController();
TextEditingController confimPasswordController = TextEditingController();

  Future<void> resetPassword(String email, String otp) async {
print(email);

      isLoading.value = true;


    try {
      // Backend's /reset-password requires exactly {email, otp, password} --
      // password_confirmation is only checked client-side (see
      // _isPasswordValid in new_password_screen.dart) before this is ever
      // called, so it doesn't need to be sent.
      final resetData = {
        'email': email,
        'otp': otp,
        'password': passwordController.text,
      };

      final response = await apiService.resetPassword(resetData);


        isLoading.value = false;


      if (response.statusCode == 200 || response.statusCode == 201) {
        passwordController.dispose();
        confimPasswordController.dispose();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Password reset successful'),backgroundColor: Colors.green,),
        );
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        var body = jsonDecode(response.body);
        ScaffoldMessenger.of(Get.context!).showSnackBar(

          SnackBar(content: Text('Password reset failed: ${body['message'] ?? 'Something went wrong'}'),backgroundColor: Colors.red,),
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