import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/add_money_screen/controller/add_money_controller.dart';
import 'package:jara_market/screens/payment_method_screen/payment_method_screen.dart';
import '../../widgets/custom_back_header.dart';

AddMoneyController controller = Get.put(AddMoneyController());

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController(text: '0');
  final FocusNode _amountFocusNode = FocusNode();
  bool _isButtonActive = false;
  final double _minimumAmount = 1000;

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

  void _navigateToPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          amount: double.parse(_amountController.text),
        ),
      ),
    );
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
                onPressed: _isButtonActive ? _navigateToPaymentMethod : null,
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
                child: const Text(
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