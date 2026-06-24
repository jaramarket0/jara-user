import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/new_password_screen/controller/new_password_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/password_input.dart';
//import '../login_screen/login_screen.dart';
//import 'package:jara_market/services/api_service.dart'; // Import ApiService

NewPasswordController controller = Get.put(NewPasswordController());

class NewPasswordScreen extends StatefulWidget {
  final String? email; // Make email optional but needed for password reset
  //final String? token; // Token from OTP verification

  const NewPasswordScreen({Key? key, this.email,}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  bool _isPasswordValid = false;
  

  void _validatePasswords() {
    setState(() {
      _isPasswordValid = controller.passwordController.text.isNotEmpty &&
          controller.passwordController.text == controller.confimPasswordController.text &&
          controller.passwordController.text.length >= 8; // Ensure password is at least 8 characters
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'New Password',
        titleColor: Colors.orange,
        onBackPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a New Password Below',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            PasswordInput(
              label: 'New Password',
              controller: controller.passwordController,
              onChanged: (_) => _validatePasswords(),
              
            ),
            const SizedBox(height: 16),
            PasswordInput(
              label: 'Confirm Password',
              controller: controller.confimPasswordController,
              onChanged: (_) => _validatePasswords(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPasswordValid && !controller.isLoading.value
                    ? () {
                        controller.resetPassword(widget.email ?? '',);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isPasswordValid ? Colors.orange : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Obx(() => Text(
                  controller.isLoading.value ? 'Processing...' : 'Submit',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}