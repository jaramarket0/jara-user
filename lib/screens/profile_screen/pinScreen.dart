import 'dart:convert';
import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/services/api_service.dart';
import 'dart:developer' as myLog;

// ─── Controller ─────────────────────────────────────────────────────────────

class PinController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 30));

  RxBool isLoading = false.obs;
  RxString pinToken = ''.obs;

  /// Set a new 4-digit transaction PIN
  Future<bool> setPin(String pin, String confirmPin) async {
    isLoading.value = true;
    try {
      final res = await _api.setPin(pin, confirmPin);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        // Get.snackbar(
        //   'PIN Set',
        //   body['message'] ?? 'Transaction PIN set successfully.',
        //   backgroundColor: const Color(0xFF22C55E),
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        // AlertInfo.show(
        //     typeInfo: TypeInfo.success,
        //     context: Get.context!,
        //     text: body['message'] ?? 'Transaction PIN set successfully.');
        Get.defaultDialog(
            title: 'Pin Set',
            content: Text(
              body['message'] ?? 'Transaction PIN set successfully.',
            ));
        return true;
      } else {
        // _showError(body['message'] ?? 'Failed to set PIN.');
        Get.defaultDialog(
            title: 'Error',
            content: Text(body['message'] ?? 'Failed to set PIN.'));
        return false;
      }
    } catch (e) {
      //_showError('Network error. Please try again.');
      Get.defaultDialog(
          title: 'Failed to set PIN.', content: Text(e.toString()));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify PIN – returns pinToken string on success, empty string on fail
  Future<String> verifyPin(String pin, {bool remember = false}) async {
    isLoading.value = true;
    myLog.log('Verifying PIN...$pin, remember: $remember');
    try {
      final res = await _api.verifyPin(pin, remember: remember);
      myLog.log('Verify PIN response: ${res.body}');
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final token = body['data']?['pin_token'] ?? body['pin_token'] ?? '';
        pinToken.value = token;
        return pin; //token;
      } else {
        //_showError(body['message'] ?? 'Incorrect PIN. Please try again.');
        AlertInfo.show(
            typeInfo: TypeInfo.error,
            context: Get.context!,
            text: 'Incorrect PIN. Please try again.');
        return '';
      }
    } catch (e) {
      _showError('Network error. Please try again.');
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> requestPinReset() async {
    isLoading.value = true;
    try {
      final res = await _api.requestPinReset();
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'Reset Requested',
          body['message'] ?? 'Check your email for a reset token.',
          backgroundColor: const Color(0xFFFFAA00),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      _showError(body['message'] ?? 'Failed to request reset.');
      return false;
    } catch (e) {
      _showError('Network error. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPin(String token, String pin, String confirmPin) async {
    isLoading.value = true;
    try {
      final res = await _api.resetPin(token, pin, confirmPin);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'PIN Reset',
          body['message'] ?? 'Your PIN has been reset successfully.',
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      _showError(body['message'] ?? 'Failed to reset PIN.');
      return false;
    } catch (e) {
      _showError('Network error. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// ─── Set PIN Screen ──────────────────────────────────────────────────────────

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({Key? key}) : super(key: key);

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final PinController _ctrl = Get.put(PinController());
  final List<TextEditingController> _pinCtrl =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _confirmCtrl =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocus = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmFocus = List.generate(4, (_) => FocusNode());

  bool _obscurePin = true;
  bool _obscureConfirm = true;

  String get _pin => _pinCtrl.map((c) => c.text).join();
  String get _confirmPin => _confirmCtrl.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in [..._pinCtrl, ..._confirmCtrl]) {
      c.dispose();
    }
    for (final f in [..._pinFocus, ..._confirmFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_pin.length < 4) {
      Get.snackbar('Error', 'Please enter your 4-digit PIN.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_pin != _confirmPin) {
      Get.snackbar('Error', 'PINs do not match.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final success = await _ctrl.setPin(_pin, _confirmPin);
    if (success && mounted) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Set Transaction PIN',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EC),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFFFFAA00).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, color: Color(0xFFFFAA00), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your PIN secures every transaction. Keep it private and never share it.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B4F00)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _PinLabel(
              label: 'Enter 4-Digit PIN',
              obscure: _obscurePin,
              onToggle: () => setState(() => _obscurePin = !_obscurePin),
            ),
            const SizedBox(height: 12),
            _PinRow(
              controllers: _pinCtrl,
              focusNodes: _pinFocus,
              nextFocusNodes: _confirmFocus,
              obscure: _obscurePin,
            ),
            const SizedBox(height: 32),
            _PinLabel(
              label: 'Confirm PIN',
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 12),
            _PinRow(
              controllers: _confirmCtrl,
              focusNodes: _confirmFocus,
              obscure: _obscureConfirm,
            ),
            const SizedBox(height: 48),
            Obx(() => _ctrl.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFAA00)))
                : SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA00),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Set PIN',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  )),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.to(() => const ResetPinScreen()),
                child: const Text(
                  'Forgot PIN? Reset it',
                  style: TextStyle(color: Color(0xFFFFAA00)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Verify PIN Dialog ───────────────────────────────────────────────────────

/// Call this to show the PIN dialog before a sensitive action.
/// Returns the pinToken on success, empty string on cancel/fail.
Future<String> showPinVerificationDialog(BuildContext context) async {
  return await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _PinVerifySheet(),
      ) ??
      '';
}

class _PinVerifySheet extends StatefulWidget {
  const _PinVerifySheet();

  @override
  State<_PinVerifySheet> createState() => _PinVerifySheetState();
}

class _PinVerifySheetState extends State<_PinVerifySheet> {
  final PinController _ctrl = Get.isRegistered<PinController>()
      ? Get.find<PinController>()
      : Get.put(PinController());
  final List<TextEditingController> _ctrl4 =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focus = List.generate(4, (_) => FocusNode());
  bool _obscure = true;

  String get _pin => _ctrl4.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _ctrl4) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_pin.length < 4) return;
    final token = await _ctrl.verifyPin(_pin);
    myLog.log('PIN verification result: $token');
    if (token.isNotEmpty && mounted) {
      Navigator.of(context).pop(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.lock_rounded, size: 40, color: Color(0xFFFFAA00)),
          const SizedBox(height: 12),
          const Text(
            'Enter Transaction PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Confirm your identity to proceed',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 28),
          _PinLabel(
            label: 'PIN',
            obscure: _obscure,
            onToggle: () => setState(() => _obscure = !_obscure),
          ),
          const SizedBox(height: 12),
          _PinRow(controllers: _ctrl4, focusNodes: _focus, obscure: _obscure),
          const SizedBox(height: 32),
          Obx(() => _ctrl.isLoading.value
              ? const CircularProgressIndicator(color: Color(0xFFFFAA00))
              : SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAA00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                )),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// ─── Reset PIN Screen ────────────────────────────────────────────────────────

class ResetPinScreen extends StatefulWidget {
  const ResetPinScreen({Key? key}) : super(key: key);

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final PinController _ctrl = Get.find<PinController>();
  final _tokenCtrl = TextEditingController();
  final List<TextEditingController> _pinCtrl =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _confirmCtrl =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocus = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmFocus = List.generate(4, (_) => FocusNode());

  String get _pin => _pinCtrl.map((c) => c.text).join();
  String get _confirmPin => _confirmCtrl.map((c) => c.text).join();

  Future<void> _submit() async {
    final success =
        await _ctrl.resetPin(_tokenCtrl.text.trim(), _pin, _confirmPin);
    if (success && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Reset PIN',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed:
                        _ctrl.isLoading.value ? null : _ctrl.requestPinReset,
                    icon: const Icon(Icons.email_outlined,
                        color: Color(0xFFFFAA00)),
                    label: const Text('Send Reset Token to Email',
                        style: TextStyle(color: Color(0xFFFFAA00))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFAA00)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            const Text('Reset Token',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _tokenCtrl,
              decoration: InputDecoration(
                hintText: 'Paste token from email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 24),
            _PinLabel(label: 'New PIN', obscure: true, onToggle: () {}),
            const SizedBox(height: 12),
            _PinRow(
                controllers: _pinCtrl,
                focusNodes: _pinFocus,
                nextFocusNodes: _confirmFocus,
                obscure: true),
            const SizedBox(height: 24),
            _PinLabel(label: 'Confirm New PIN', obscure: true, onToggle: () {}),
            const SizedBox(height: 12),
            _PinRow(
                controllers: _confirmCtrl,
                focusNodes: _confirmFocus,
                obscure: true),
            const SizedBox(height: 40),
            Obx(() => _ctrl.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFAA00)))
                : SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA00),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Reset PIN',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _PinLabel extends StatelessWidget {
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  const _PinLabel(
      {required this.label, required this.obscure, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        GestureDetector(
          onTap: onToggle,
          child: Icon(obscure ? Icons.visibility_off : Icons.visibility,
              size: 18, color: Colors.grey),
        ),
      ],
    );
  }
}

class _PinRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<FocusNode>? nextFocusNodes;
  final bool obscure;

  const _PinRow({
    required this.controllers,
    required this.focusNodes,
    this.nextFocusNodes,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 60,
          height: 60,
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            obscureText: obscure,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFFFAA00), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            onChanged: (val) {
              if (val.length == 1) {
                if (i < 3) {
                  FocusScope.of(context).requestFocus(focusNodes[i + 1]);
                } else if (nextFocusNodes != null) {
                  FocusScope.of(context).requestFocus(nextFocusNodes![0]);
                } else {
                  focusNodes[i].unfocus();
                }
              }
            },
          ),
        );
      }),
    );
  }
}
