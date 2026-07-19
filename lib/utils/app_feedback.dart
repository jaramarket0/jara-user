import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Central place for showing user-facing error messages.
/// Converts raw exceptions (SocketException, timeouts, etc.) into
/// friendly text instead of dumping stack traces on the user.
class AppFeedback {
  AppFeedback._();

  static bool _isNetworkError(Object? error) {
    if (error is TimeoutException) return true;
    final msg = error?.toString().toLowerCase() ?? '';
    return msg.contains('socketexception') ||
        msg.contains('failed host lookup') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused') ||
        msg.contains('connection reset') ||
        msg.contains('connection closed') ||
        msg.contains('clientexception') ||
        msg.contains('handshakeexception') ||
        msg.contains('timeout');
  }

  static String friendlyMessage(Object? error, {String? fallback}) {
    if (_isNetworkError(error)) {
      if (error is TimeoutException ||
          (error?.toString().toLowerCase().contains('timeout') ?? false)) {
        return 'This is taking longer than usual. Please check your connection and try again.';
      }
      return 'No internet connection. Please check your network and try again.';
    }
    return fallback ?? 'Something went wrong. Please try again.';
  }

  /// Shows a friendly floating snackbar for [error].
  /// Safe to call after dialogs/navigation (uses ScaffoldMessenger, not overlay).
  static void showError(Object? error, {String? fallback}) {
    final ctx = Get.context;
    if (ctx == null) return;
    final network = _isNetworkError(error);

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF212429),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              network ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              color: const Color(0xFFFFAA00),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friendlyMessage(error, fallback: fallback),
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Success variant with the same friendly styling.
  static void showSuccess(String message) {
    final ctx = Get.context;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF212429),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF22C55E), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
