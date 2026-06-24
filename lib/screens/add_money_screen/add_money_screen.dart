import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/add_money_screen/controller/add_money_controller.dart';
import 'dart:convert';
import 'package:jara_market/screens/payment_method_screen/payment_method_screen.dart';
import '../../widgets/custom_back_header.dart';
import '../../services/api_service.dart';

AddMoneyController controller = Get.put(AddMoneyController());

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController(text: '0');
  final FocusNode _amountFocusNode = FocusNode();
   ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isButtonActive = false;
  final double _minimumAmount = 1000;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-select the text when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_amountFocusNode);
      _amountController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _amountController.text.length,
      );
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fundWallet() async {
    try {
      // Prepare the data for the API call
      final fundData = {
        'amount': double.parse(_amountController.text),
        'user_id': 'user123', // Replace with actual user ID from auth provider
        'payment_method': 'card', // This will be selected in the payment method screen
      };

      // Call the API service method
      final response = await _apiService.fundWallet(fundData);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Wallet funded successfully');
        return jsonDecode(response.body);
      } else {
        // Handle error response
        print('Failed to fund wallet: ${response.statusCode}');
        throw Exception('Failed to fund wallet: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error funding wallet: $e');
      throw e;
    }
  }

  void _navigateToPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          amount: double.parse(_amountController.text),
        ),
      ),
    );

    // If payment method was selected and payment was successful
    if (result != null && result['success'] == true) {
      // Return to wallet screen with success result
      Navigator.pop(context, {
        'amount': double.parse(_amountController.text),
        'success': true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomBackHeader(title: 'Add money'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Amount input with Naira symbol
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          '₦',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBABABA),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: TextInputType.number,
                            
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Color(0xffBABABA),),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              // Remove leading zeros
                              if (value.startsWith('0') && value.length > 1) {
                                _amountController.text = value.substring(1);
                                _amountController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _amountController.text.length),
                                );
                              }
                              // Check if the amount is greater than minimum amount
                              setState(() {
                                _isButtonActive = (double.tryParse(_amountController.text) ?? 0) > _minimumAmount;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    // Orange underline
                    Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                      width: double.infinity,
                    ),

                    // Minimum amount message
                    if (!_isButtonActive && _amountController.text != '0')
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Minimum amount is ₦${_minimumAmount.toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _isButtonActive && !_isLoading
                    ? () async {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    await _fundWallet();
                    if (mounted) {
                      _navigateToPaymentMethod();
                    }
                  } catch (e) {
                    print('Error: $e');
                    // Even if there's an error, we still navigate
                    if (mounted) {
                      _navigateToPaymentMethod();
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Adjust opacity for disabled state
                  disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                  disabledForegroundColor: Colors.white.withOpacity(0.7),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}