// lib/screens/auth/otp_verification.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/otp_verification/controller/otp_verification_controller.dart';
import '../../widgets/customized_app_bar.dart';
import '../../widgets/otp_input.dart';
import '../../widgets/countdown_timer.dart';
import '../new_password_screen/new_password_screen.dart';
import 'package:jara_market/services/api_service.dart';

OtpVerificationController controller = Get.put(OtpVerificationController());

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  //final TextEditingController _otpController = TextEditingController();
  //ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isVerifying = false;



  @override
  void initState() {
    super.initState();
    controller.startCountdown();
    controller.otpController.addListener(() {
      setState(() {
        _isVerifying = controller.otpController.text.length == 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OTP Verification',
        titleColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We have sent a confirmation code to your mail at ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            OtpInput(
              controller: controller.otpController,
              onCompleted: (String value) {
                setState(() {
                  _isVerifying = value.length == 4;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Didn't Receive Code,",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: (){
                    controller.resendOtp({"email": widget.email});
                  },
                  child: const Text(
                    'Send A New Code',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Obx(() {
              return controller.showCountdown.value
                  ? const CountdownTimer(duration: Duration(minutes: 15))
                  : const SizedBox.shrink();
            }),
            const Spacer(),
            Obx((){
              return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying && !controller.isLoading.value
                    ? () {
                        controller.validateOtp({
                          'email': widget.email,
                          'otp': controller.otpController.text,
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerifying ? Colors.orange : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  controller.isLoading.value ? 'Verifying...' : 'Verify',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            );
            })
          ],
        ),
      ),
    );
  }
}
