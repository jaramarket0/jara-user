// lib/screens/auth/signup_screen.dart
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/auth_service.dart';
import 'package:jara_market/screens/signup_screen/controller/signup_controller.dart';
//import 'package:jara_market/services/api_service.dart';
import '../../widgets/register_button.dart';
import '../../widgets/custom_text_field.dart';
// import '../legal/terms_of_service_screen.dart';
// import '../legal/privacy_policy_screen.dart';
// import '../email_verification/email_verification.dart';
import '../../widgets/social_button.dart'; // Import SocialButton

SignupController controller = Get.put(SignupController());

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  // final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _referralCodeController = TextEditingController(); // Add referral code controller
  // final ApiService _apiService = ApiService();
  String? _errorFirstName;
  String? _errorLastName;
  String? _errorEmail;
  String? _errorPassword;
  String? _errorPhoneNumber;

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorEmail = 'Email is required';
      } else if (!value.contains('@')) {
        _errorEmail = 'Enter a valid email';
      } else {
        _errorEmail = null;
      }
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorEmail = 'Phone number is required';
      } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
        _errorEmail = 'Enter a valid phone number';
      } else {
        _errorEmail = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorPassword = 'Password is required';
      } else if (value.length < 8) {
        _errorPassword = 'Password must be at least 8 characters';
      } else {
        _errorPassword = null;
      }
    });
  }

  void _validateFirstName(String value) {
    setState(() {
      if (value.trim().isEmpty || value == null) {
        _errorFirstName = 'First name is required';
      } else if (value.length < 2) {
        _errorFirstName = 'First name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        _errorFirstName = 'First name can only contain letters';
      } else if (value.contains(RegExp(r'\d'))) {
        _errorFirstName = 'First name cannot contain numbers';
      } else if (value.contains(RegExp(r'[@!#\$%^&*(),.?":{}|<>]'))) {
        _errorFirstName = 'First name cannot contain special characters';
      } else {
        _errorFirstName = null;
      }
    });
  }

  void _validateLastName(String value) {
    setState(() {
      if (value.trim().isEmpty || value == null) {
        _errorLastName = 'Last name is required';
      } else if (value.length < 2) {
        _errorLastName = 'Last name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        _errorLastName = 'Last name can only contain letters';
      } else if (value.contains(RegExp(r'\d'))) {
        _errorLastName = 'Last name cannot contain numbers';
      } else if (value.contains(RegExp(r'[@!#\$%^&*(),.?":{}|<>]'))) {
        _errorLastName = 'Last name cannot contain special characters';
      } else {
        _errorLastName = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.firstNameController.addListener(_validateForm);
    controller.lastNameController.addListener(_validateForm);
    controller.emailController.addListener(_validateForm);
    controller.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final firstName = controller.firstNameController.text;
    final lastName = controller.lastNameController.text;
    final email = controller.emailController.text;
    final password = controller.passwordController.text;
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final passwordValid = password.length >= 8;

    setState(() {
      _isButtonEnabled = firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          emailValid &&
          passwordValid &&
          _agreeToTerms;
    });
  }

  // Future<void> _registerCustomer() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final customerData = {
  //       'firstname': _firstNameController.text,
  //       'lastname': _lastNameController.text,
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //       'referral_code': _referralCodeController.text, // Add referral code to customer data
  //     };

  //     final response = await controller.registerCustomer();

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => EmailVerificationScreen(email: _emailController.text),
  //         ),
  //       );
  //     } else {
  //     var  responseBody = jsonDecode(response.body);
  //        var message = responseBody['message'] ?? 'something went wrong';
  //       ScaffoldMessenger.of(context).showSnackBar(

  //         SnackBar(content: Text('Registration failed: ${message}')),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _referralCodeController.dispose(); // Dispose referral code controller
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Locate the injected controller
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome! please enter your details.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                onChanged: (p0) {
                  _validateFirstName(p0);
                },
                controller: controller.firstNameController,
                errorText: _errorFirstName,
                hint: "First Name",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                onChanged: (p0) {
                  _validateLastName(p0);
                },
                errorText: _errorLastName,
                controller: controller.lastNameController,
                hint: "Last Name",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                onChanged: (p0) {
                  _validateEmail(p0);
                },
                errorText: _errorEmail,
                controller: controller.emailController,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                onChanged: (p0) {
                  _validatePhoneNumber(p0);
                },
                errorText: _errorPhoneNumber,
                controller: controller.phoneNumberController,
                hint: "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                onChanged: (p0) {
                  _validatePassword(p0);
                },
                errorText: _errorPassword,
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
              CustomTextField(
                controller: controller.referralCodeController,
                hint:
                    "Referral Code (optional)", // Add referral code input field
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                        _validateForm();
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: "I agree to the "),
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                                // );
                                Get.toNamed('/terms_of_service_screen');
                              },
                          ),
                          const TextSpan(text: " & "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                // );
                                Get.toNamed('/privacy_policy_screen');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RegisterButton(
                text: _isLoading ? "Processing..." : "Sign Up",
                onPressed: (_isButtonEnabled && !_isLoading)
                    ? controller.registerCustomer
                    : null,
                color: _isButtonEnabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("or sign up with"),
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
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Log In"),
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
