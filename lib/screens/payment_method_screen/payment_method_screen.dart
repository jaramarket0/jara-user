
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
import 'package:jara_market/screens/payment_method_screen/controller/payment_method_controller.dart';
import 'dart:convert';
import 'package:jara_market/widgets/payment_method_cards.dart';
import '../../widgets/custom_back_header.dart';
import '../../services/api_service.dart';

PaymentMethodController controller = Get.put(PaymentMethodController());
CheckoutController checkoutController = Get.put(CheckoutController());
class PaymentMethodScreen extends StatefulWidget {
  final double amount;
  
  const PaymentMethodScreen({
    Key? key, 
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  String _selectedMethod = 'mastercard';
  
  String? _errorMessage;
//checkoutController.initializeCheckout(amount);
  // Future<void> _processPayment() async {
  //   try {
  //     setState(() {
  //       _isProcessing = true;
  //       _errorMessage = null;
  //     });

  //     // Prepare payment data
  //     final paymentData = {
  //       'amount': widget.amount,
  //       'payment_method': _selectedMethod,
  //       'user_id': 'user123', // Replace with actual user ID from auth provider
  //       'currency': 'NGN',
  //       'description': 'Wallet funding',
  //     };

  //     // Create payment
  //     final response = await _apiService.createPayment(paymentData);
      
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
        
  //       // Check if we need to redirect to a payment gateway
  //       if (responseData['redirect_url'] != null) {
  //         // In a real app, you would open a WebView or redirect to the payment gateway
  //         print('Redirecting to payment gateway: ${responseData['redirect_url']}');
          
  //         // Simulate payment gateway callback
  //         await Future.delayed(const Duration(seconds: 2));
          
  //         // Handle payment callback
  //         final callbackResponse = await _apiService.handlePaymentCallback({
  //           'transaction_id': responseData['transaction_id'],
  //           'status': 'success',
  //         });
          
  //         if (callbackResponse.statusCode == 200) {
  //           // Payment successful
  //           Navigator.pop(context, {'success': true});
  //         } else {
  //           throw Exception('Payment verification failed');
  //         }
  //       } else {
  //         // Direct payment success
  //         Navigator.pop(context, {'success': true});
  //       }
  //     } else {
  //       throw Exception('Payment failed: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Error: $e';
  //     });
  //     print(_errorMessage);
  //   } finally {
  //     setState(() {
  //       _isProcessing = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackHeader(title: 'Payment'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select the method for your payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    const SizedBox(height: 24),
                    PaymentMethodCards(
                      title: 'Visa Card',
                      description: 'Lorem ipsum dolor sit amet consectetur. In integer cras neque phasellus augue ornare est nec. Elemen',
                      icon: Image.asset(
                        'assets/images/Visa.png',
                        width: 48,
                        height: 32,
                      ),
                      isSelected: _selectedMethod == 'visa',
                      onTap: () {
                        setState(() {
                          _selectedMethod = 'visa';
                        });
                      },
                    ),
                    PaymentMethodCards(
                      title: 'MasterCard',
                      description: 'Lorem ipsum dolor sit amet consectetur. In integer cras neque phasellus augue ornare est nec. Elemen',
                      icon: Image.asset(
                        'assets/images/Mastercard.png',
                        width: 48,
                        height: 32,
                      ),
                      isSelected: _selectedMethod == 'mastercard',
                      onTap: () {
                        setState(() {
                          _selectedMethod = 'mastercard';
                        });
                      },
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    Obx((){
                      return ElevatedButton(
                      onPressed: checkoutController.isLoading.value ? null : () => checkoutController.initializeCheckout(widget.amount),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        disabledForegroundColor: Colors.white.withOpacity(0.7),
                      ),
                      child: checkoutController.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Pay ₦${widget.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}