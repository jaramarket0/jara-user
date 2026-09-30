// lib/utils/guest_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/config/routes.dart';

/// Tracks whether the app is being used without an account.
///
/// Guests can browse the catalog, search, change location and build a cart.
/// Anything tied to an account (checkout, wallet, orders, profile,
/// favorites) goes through [requireAccount] or [GuestPlaceholder] instead.
class Session {
  Session._();

  static final RxBool isGuest = true.obs;

  /// Re-reads the stored token. Call on startup and whenever the main shell
  /// is (re)built, since login/logout always route back through it.
  static Future<void> refresh() async {
    final token = await Get.find<DataBase>().getToken();
    isGuest.value = token.isEmpty;
  }
}

/// Resets the stack to the home screen with login pushed on top, so Back
/// from login always lands in the app rather than on a dead end.
void openLoginOverHome() {
  Get.offAllNamed(AppRoutes.mainScreen);
  Get.toNamed(AppRoutes.loginScreen);
}

/// Returns true when signed in. For guests, shows a sheet offering sign in /
/// sign up and returns false so the caller can bail out.
Future<bool> requireAccount(BuildContext context,
    {String message = 'Sign in or create an account to continue.'}) async {
  if (!Session.isGuest.value) return true;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: _SignInPrompt(
          message: message,
          onAction: () => Navigator.pop(sheetContext),
        ),
      ),
    ),
  );
  return false;
}

/// Full-screen stand-in for account-only tabs (Orders, Profile) when browsing
/// as a guest.
class GuestPlaceholder extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const GuestPlaceholder({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.person_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 44, color: const Color(0xFFFFAA00)),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _SignInPrompt(message: message, showTitle: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  final String message;
  final bool showTitle;
  final VoidCallback? onAction;

  const _SignInPrompt({
    required this.message,
    this.showTitle = true,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle) ...[
          const Text(
            'Account required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              onAction?.call();
              Get.toNamed(AppRoutes.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAA00),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sign In',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              onAction?.call();
              Get.toNamed(AppRoutes.signupScreen);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Color(0xFFFFAA00)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Create Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}
