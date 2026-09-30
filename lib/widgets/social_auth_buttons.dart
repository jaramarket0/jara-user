// lib/widgets/social_auth_buttons.dart
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/auth_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Full-width Apple + Google sign-in buttons shared by login and signup.
///
/// Apple's guidelines require Sign in with Apple to be at least as prominent
/// as any other third-party option, so it uses Apple's official button and
/// sits first, at the same size as the Google button.
class SocialAuthButtons extends StatelessWidget {
  /// 'Sign in' on the login screen, 'Sign up' on the signup screen.
  final bool isSignUp;

  const SocialAuthButtons({Key? key, this.isSignUp = false}) : super(key: key);

  static const double _height = 52;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(() {
      final busy = authController.loadingProvider.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Platform.isIOS) ...[
            busy == 'apple'
                ? _loadingBox(Colors.black, Colors.white)
                : AbsorbPointer(
                    absorbing: busy.isNotEmpty,
                    child: SignInWithAppleButton(
                      text: isSignUp ? 'Sign up with Apple' : 'Sign in with Apple',
                      height: _height,
                      style: SignInWithAppleButtonStyle.black,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(_radius)),
                      onPressed: authController.loginWithApple,
                    ),
                  ),
            const SizedBox(height: 12),
          ],
          busy == 'google'
              ? _loadingBox(Colors.white, Colors.black87, bordered: true)
              : SizedBox(
                  height: _height,
                  child: OutlinedButton.icon(
                    onPressed:
                        busy.isEmpty ? authController.loginWithGoogle : null,
                    icon: const Icon(Icons.g_mobiledata, size: 32),
                    label: Text(
                      isSignUp ? 'Sign up with Google' : 'Sign in with Google',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_radius)),
                    ),
                  ),
                ),
        ],
      );
    });
  }

  Widget _loadingBox(Color background, Color spinner, {bool bordered = false}) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(_radius),
        border: bordered ? Border.all(color: Colors.black26) : null,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: spinner),
        ),
      ),
    );
  }
}
