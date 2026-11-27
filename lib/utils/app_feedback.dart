import 'dart:async';
import 'dart:convert';

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

  static const String _generic = 'Something went wrong. Please try again.';

  /// True when [text] looks like machine output rather than a sentence for a
  /// person: JSON, an HTML error page, a stack trace, an exception's
  /// toString(). Any of those on screen reads as a crash, even when the app
  /// has handled the problem perfectly well.
  static bool _looksLikeRawData(String text) {
    final t = text.trim();
    if (t.isEmpty) return true;
    if (t.startsWith('{') || t.startsWith('[') || t.startsWith('<')) return true;
    const markers = [
      '{"', '":', '<html', '<!doctype', 'exception:', 'exception (',
      'stacktrace', 'stack trace', '#0 ', 'statuscode', 'null check',
      'type \'', 'is not a subtype',
    ];
    final lower = t.toLowerCase();
    if (markers.any(lower.contains)) return true;
    // Nothing written for a human runs this long in a snackbar.
    return t.length > 180;
  }

  /// Keeps the human half of messages like
  /// "Failed to load states: {\"status\":false,...}" and drops the payload,
  /// rather than throwing the whole thing away.
  static String _sanitise(String text) {
    for (final sep in [': {', ': [', ': <', ': Exception', ': ClientException']) {
      final i = text.indexOf(sep);
      if (i > 0) {
        final prefix = text.substring(0, i).trim();
        if (prefix.isNotEmpty && !_looksLikeRawData(prefix)) {
          return prefix.endsWith('.') ? prefix : '$prefix.';
        }
      }
    }
    return _looksLikeRawData(text) ? _generic : text;
  }

  static String friendlyMessage(Object? error, {String? fallback}) {
    if (_isNetworkError(error)) {
      if (error is TimeoutException ||
          (error?.toString().toLowerCase().contains('timeout') ?? false)) {
        return 'This is taking longer than usual. Please check your connection and try again.';
      }
      return 'No internet connection. Please check your network and try again.';
    }
    // Last line of defence: a caller that interpolates a response body or an
    // exception into its fallback must not reach the screen with it. Checked
    // here rather than at each call site so it holds for call sites nobody
    // has revisited.
    if (fallback != null && fallback.trim().isNotEmpty) {
      return _sanitise(fallback);
    }
    return _generic;
  }

  /// Error text for a failed API call.
  ///
  /// Prefers the server's own `message`, since the backend already phrases
  /// these for customers, and falls back to something sensible for the status
  /// code when the body is unusable. Never shows the body itself.
  static String messageFromResponse(dynamic response, {String? fallback}) {
    int? status;
    String? body;
    try {
      status = response?.statusCode as int?;
      body = response?.body as String?;
    } catch (_) {
      // Not an http.Response; fall through to the status-code defaults.
    }

    if (body != null && body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) {
          final msg = decoded['message'] ?? decoded['detail'] ?? decoded['error'];
          if (msg is String && msg.trim().isNotEmpty && !_looksLikeRawData(msg)) {
            return msg.trim();
          }
        }
      } catch (_) {
        // Not JSON -- an HTML error page or a proxy message. Never shown.
      }
    }

    switch (status) {
      case 400:
      case 422:
        return fallback ?? 'Please check the details you entered and try again.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You don\'t have permission to do that.';
      case 404:
        return fallback ?? 'We couldn\'t find what you were looking for.';
      case 429:
        return 'Too many attempts. Please wait a moment and try again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'We\'re having trouble on our end. Please try again shortly.';
    }
    return fallback ?? _generic;
  }

  /// Shows [messageFromResponse] for a failed API call.
  static void showApiError(dynamic response, {String? fallback}) {
    _show(messageFromResponse(response, fallback: fallback), network: false);
  }

  /// Shows a friendly floating snackbar for [error].
  /// Safe to call after dialogs/navigation (uses ScaffoldMessenger, not overlay).
  static void showError(Object? error, {String? fallback}) {
    _show(friendlyMessage(error, fallback: fallback),
        network: _isNetworkError(error));
  }

  static void _show(String message, {required bool network}) {
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
            Icon(
              network ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              color: const Color(0xFFFFAA00),
              size: 20,
            ),
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
