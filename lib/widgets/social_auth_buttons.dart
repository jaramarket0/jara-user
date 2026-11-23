// lib/widgets/social_auth_buttons.dart
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/auth_service.dart';
import 'package:jara_market/widgets/custom_text_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Full-width Apple + Google sign-in buttons shared by login and signup.
///
/// Apple's guidelines require Sign in with Apple to be at least as prominent
/// as any other third-party option, so it uses Apple's official button and
/// sits first, at the same size as the Google button.
class SocialAuthButtons extends StatefulWidget {
  /// 'Sign in' on the login screen, 'Sign up' on the signup screen.
  final bool isSignUp;

  /// Friend's referral code to send with Google/Apple sign-up. The signup
  /// screen passes its own referral field; without one (login screen) these
  /// buttons offer a small "Have a referral code?" field of their own.
  final TextEditingController? referralCodeController;

  const SocialAuthButtons(
      {Key? key, this.isSignUp = false, this.referralCodeController})
      : super(key: key);

  @override
  State<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends State<SocialAuthButtons> {
  static const double _height = 52;
  static const double _radius = 12;

  final TextEditingController _ownReferralController = TextEditingController();
  bool _showReferralField = false;

  TextEditingController get _referral =>
      widget.referralCodeController ?? _ownReferralController;

  @override
  void dispose() {
    _ownReferralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isSignUp = widget.isSignUp;
    return Obx(() {
      final busy = authController.loadingProvider.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.referralCodeController == null) ...[
            if (_showReferralField) ...[
              CustomTextField(
                controller: _ownReferralController,
                hint: 'Referral Code (optional)',
              ),
              const SizedBox(height: 12),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _showReferralField = true),
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFFAA00)),
                  child: const Text('New here? Have a referral code?'),
                ),
              ),
          ],
          if (Platform.isIOS) ...[
            busy == 'apple'
                ? _loadingBox(Colors.black, Colors.white)
                : AbsorbPointer(
                    absorbing: busy.isNotEmpty,
                    child: SignInWithAppleButton(
                      text: isSignUp
                          ? 'Sign up with Apple'
                          : 'Sign in with Apple',
                      height: _height,
                      style: SignInWithAppleButtonStyle.black,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(_radius)),
                      onPressed: () => authController.loginWithApple(
                          referralCode: _referral.text),
                    ),
                  ),
            const SizedBox(height: 12),
          ],
          busy == 'google'
              ? _loadingBox(Colors.white, Colors.black87, bordered: true)
              : SizedBox(
                  height: _height,
                  child: OutlinedButton.icon(
                    onPressed: busy.isEmpty
                        ? () => authController.loginWithGoogle(
                            referralCode: _referral.text)
                        : null,
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
