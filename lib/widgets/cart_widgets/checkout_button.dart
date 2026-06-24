import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/checkout_screen/checkout_flow.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/screens/wallet_screen/models/models.dart';
import 'package:jara_market/screens/wallet_screen/withdraw_screen.dart';
import '../../screens/checkout_screen/checkout_screen.dart';
// import '../../models/cart_item.dart';

var controller = Get.find<CartController>();
WalletController walletController = Get.put(WalletController());

class CheckoutButton extends StatefulWidget {
  final bool isEnabled;
  final double totalAmount;
  final String? path;

  final bool loading;
  final List<CartItem> cartItems;

  const CheckoutButton(
      {super.key,
      required this.isEnabled,
      required this.totalAmount,
      required this.cartItems,
      this.path,
      required this.loading});

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  WalletModel? walletModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: widget.isEnabled
            ? () async {
                //  Navigate to the CheckoutScreen
                var checkoutAddress = await controller.getCheckoutAddress();
                var balance = await walletController.fetchBalance();
                print(balance);
                myLog.log('printing balance $balance');
                if (balance == -1) return;
                if (checkoutAddress.isNotEmpty) {
                  var data = checkoutAddress['data'][0];
                  // Use `data` here
                  myLog.log('Checkout Address first index data: $data');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        totalAmount: widget.totalAmount,
                        cartItems: widget.cartItems,
                        orderAddress: data,
                        balance: balance,
                        //isEnabled: widget.isEnabled,
                        path: widget.path ?? '',
                      ),
                    ),
                  );
                } else {
                  var balance = await walletController.fetchBalance();
                  if (balance == -1) return;
                  // Handle empty state
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        totalAmount: widget.totalAmount,
                        cartItems: widget.cartItems,
                        orderAddress: {},
                        balance: balance,
                        // isEnabled: widget.isEnabled,
                        path: widget.path ?? '',
                      ),
                    ),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.isEnabled ? const Color(0xFFFF9800) : Colors.grey,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          widget.loading ? "Processing..." : 'Pay',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
