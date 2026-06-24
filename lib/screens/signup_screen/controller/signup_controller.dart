import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/email_verification/email_verification.dart';
import 'package:jara_market/screens/signup_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';

class SignupController extends GetxController {
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

// SignupController() {
//     // Optionally, you can initialize any other variables or services here
//   }

SignupModel signupModel = SignupModel(status: true, message: '', data: Data());
Data data = Data();
DataBase database = DataBase();
  Future<void> registerCustomer() async {
    isLoading = true;

    try {
      final customerData = {
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'email': emailController.text,
        "phone_number": phoneNumberController.text,
        'password': passwordController.text,
        'referral_code': referralCodeController.text, // Add referral code to customer data
        "role": "customer",
      };
//       {
//         "firstname": "Daniel",
//         "lastname": "Ekwere",
//         "email": "ekweredaniel8@gmail.com",
//         "password": "interpo1",
//         "phone_number": "07043194111",
//         "role": "customer"
// }
myLog.log('Customer Data: $customerData', name: 'SignupController');
      final response = await _apiService.registerCustomer(customerData);

  isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigator.push(
        //   Get.context!,
        //   MaterialPageRoute(
           //  builder: (context) => EmailVerificationScreen(email: emailController.text),
        //   ),
        // );
               signupModel = signupModelFromJson(response.body);
            //   data = signupModel.data;
            // await  database.saveUserId(data.id!.toInt()); //data.id is int ? data.id as int : 0
            // await  database.saveFirstName(data.firstname ?? 'N/A');
            // await  database.saveLastName(data.lastname ?? 'N/A');
            // await  database.saveFullName(data.name ?? 'N/A');
            // await  database.saveEmail(data.email ?? 'N/A');
            // await  database.savePhoneNumber(data.phoneNumber ?? 'N/A');
            // await  database.saveRole(data.role ?? 'N/A');
            // await  database.saveReferalCode(data.referralCode ?? 'N/A');
            // await  database.saveReferalCount(data.referralCount ?? 'N/A');
            // await  database.saveRefererId(data.referrerId ?? 'N/A');
            ScaffoldMessenger.of(Get.context!).showSnackBar(
         
          SnackBar(content: Text('Success: \n${signupModel.message}'),backgroundColor: Colors.green,),
        );
        Get.toNamed('/emailVerificationScreen', arguments: {
          'email': emailController.text,
        });

      } else {
      var  responseBody = jsonDecode(response.body);
         var message = responseBody['message'] ?? 'something went wrong';
        ScaffoldMessenger.of(Get.context!).showSnackBar(
         
          SnackBar(content: Text('Registration failed: ${message}')),
        );
      }
    } catch (e) {
    isLoading = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
        
      );
      myLog.log('Error: $e', name: 'SignupController');
    }
  }
}