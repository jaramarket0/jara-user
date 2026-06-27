import 'package:jara_market/main.dart';
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/add_address_to_discover/add_address_screen.dart';
import 'package:jara_market/screens/login_screen/models/models.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/services/api_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RxBool isButtonEnabled = false.obs;

  RxBool isLoading = false.obs;
  // bool get isLoading => _isLoading;

  LoginModel loginModel =
      LoginModel(status: true, message: '', data: LoginData());
  LoginData data = LoginData();

  // set isLoading(bool value) {
  //   _isLoading = value;
  //   update();
  // }

  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    isLoading.value = true;

    try {
      final response = await _apiService.login({
        'email': emailController.text,
        'password': passwordController.text,
      });

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginModel = loginModelFromJson(response.body);
        data = loginModel.data;
        myLog.log('Login Message: ${loginModel.message}',
            name: 'LoginController');
        // Save token and user data to shared preferences
        await dataBase.saveToken(data.token ?? 'N/A');
        await dataBase
            .saveUserId(data.id!.toInt()); //data.id is int ? data.id as int : 0
        await dataBase.saveFirstName(data.firstname ?? 'N/A');
        await dataBase.saveLastName(data.lastname ?? 'N/A');
        await dataBase.saveFullName(data.name ?? 'N/A');
        await dataBase.saveEmail(data.email ?? 'N/A');
        await dataBase.savePhoneNumber(data.phoneNumber ?? 'N/A');
        await dataBase.saveRole(data.role ?? 'N/A');
        await dataBase.saveReferalCode(data.referralCode ?? 'N/A');
        await dataBase
            .saveReferalCount(data.referralCount?.toString() ?? 'N/A');
        await dataBase.saveRefererId(data.referrerId?.toString() ?? 'N/A');

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Success: ${loginModel.message}'),
            backgroundColor: Colors.green,
          ),
        );
        String stateId = await dataBase.getStateAddressId();
        if (stateId.isNotEmpty) {
          myLog.log('State ID: $stateId');
          Get.offAllNamed('/main_screen');
        } else {
          Get.offAll(() => AddAddressScreen());
          myLog.log('State ID not found in local storage.');
        }
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
                'Login failed: ${jsonDecode(response.body)['message']}\n description: ${jsonDecode(response.body)['errors']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error during login: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
