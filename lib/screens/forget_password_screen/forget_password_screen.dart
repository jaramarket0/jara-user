import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/forget_password_screen/controller/forget_password_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../otp_verification/otp_verification.dart';
import '../../widgets/customized_text_field.dart';
import 'package:jara_market/services/api_service.dart'; // Import ApiService

ForgetPasswordController controller = Get.put(ForgetPasswordController());

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  //final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  // bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    controller.emailController.text = '';
    _validateEmail();
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(controller.emailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Forget Password',
        titleColor: Colors.orange,
        onBackPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered email below',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Email',
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter your email',
              onChanged: (value) {
                _validateEmail();
              },
            ),
            const Spacer(),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isEmailValid && !controller.isLoading.value
                      ? controller.requestPasswordReset
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        _isEmailValid ? Colors.orange : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    controller.isLoading.value ? 'Processing...' : 'Verify',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
