// lib/screens/auth/login_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/auth_service.dart';
import 'package:jara_market/screens/login_screen/controller/login_controller.dart';
import 'package:jara_market/screens/signup_screen/signup_screen.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/widgets/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
// import '../home_screen/home_screen.dart';
import '../forget_password_screen/forget_password_screen.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_button.dart';
//import 'package:jara_market/screens/email_verification/email_verification.dart'; // Import EmailVerificationScreen

LoginController controller = Get.put(LoginController());

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _keepLoggedIn = false;
  bool _isPasswordVisible = false;
  
  



  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.emailController.addListener(_validateForm);
    controller.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = controller.emailController.text;
    final password = controller.passwordController.text;
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final passwordValid = password.length >= 8;

    setState(() {
      controller.isButtonEnabled.value = emailValid && passwordValid;
    });
  }

  Future<void> _saveUserData(Map<String, dynamic> responseData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save token
      await prefs.setString('token', responseData['token']);

      // Save user data
      final userData = responseData['data'];
      await prefs.setString('user_email', userData['email']);
      await prefs.setInt('user_id', userData['user_id']);
      await prefs.setString('user_name', userData['name']);
      await prefs.setString('user_lastname', userData['lastname']);

      // Optional: Save the entire user data object as JSON
      await prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      print('Error saving user data: $e');
      // You might want to handle this error appropriately
    }
  }

  // Future<void> _login() async {
  //   // if (!_formKey.currentState!.validate()) {
  //   //   return;
  //   // }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final response = await _apiService.login({
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //     });

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final responseData = jsonDecode(response.body);

  //       // Save user data and token
  //       await _saveUserData(responseData);

  //       // Navigate to home screen
  //       if (mounted) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const MainScreen()),
  //         );
  //       }
  //     } else {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Login failed: ${response.body}'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error during login: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   controller.emailController.dispose();
  //   controller.passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Access your account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please enter your details.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: controller.emailController,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                hint: "Password",
                isPassword: true,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _keepLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        _keepLoggedIn = value!;
                      });
                    },
                  ),
                  const Text("Keep Me Logged In"),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return LoginButton(
                text: controller.isLoading.value ? "Processing..." : "Log In",
                onPressed: (controller.isButtonEnabled.value && !controller.isLoading.value) ? controller.login : null,
                color: controller.isButtonEnabled.value ? Colors.orange : Colors.grey,
              );
              },),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()),
                  );
                },
                child: const Text("Forgot Password?"),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("or log in with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialButton(
                    icon: Icons.apple,
                    onPressed: () {},
                  ),
                  SocialButton(
                    icon: Icons.g_mobiledata,
                    onPressed: () {
                      authController.loginWithGoogle();
                    },
                  ),
                  SocialButton(
                    icon: Icons.facebook,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
