import 'dart:developer' as myLog;
import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_address_change/checkout_address_change.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
import 'package:jara_market/screens/checkout_screen/location_servies/location_service.dart';
import 'package:jara_market/screens/checkout_screen/models/location_model.dart';
import 'package:jara_market/screens/profile_screen/pinScreen.dart';
// import '../../models/cart_item.dart';

CheckoutController checkoutController = Get.find<CheckoutController>();

class CheckoutButtonPaystack extends StatelessWidget {
  final void Function(UserLocation location) onLocationDetected;
  final String title;
  final double amount;
  final Color? color;
  final String? audio;
  final String? address;

  const CheckoutButtonPaystack(
      {super.key,
      required this.title,
      required this.amount,
      this.color,
      required this.address,
      required this.onLocationDetected,
      required this.audio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          myLog.log(address.toString());
          myLog.log(amount.toString());
          // Navigate to the CheckoutScreen
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CheckoutScreen(

          //     ),
          //   ),
          // );
          Get.defaultDialog(
            textConfirm: 'Proceed',
            textCancel: 'No use My Current Location',
            title: 'Confirm Address',
            content: Text(
                'Will Deliver your order to this address?\n\n$address',
                textAlign: TextAlign.center),
            onCancel: () async {
              AlertInfo.show(
                  context: context,
                  text: 'We\'re Fetching Your Current Location...',
                  duration: 5);
              await checkoutController.detectLocation();
              if (checkoutController.hasLocation) {
                // onLocationDetected(checkoutController.currentLocation.value!);

                final location = await LocationService.getCurrentLocation();

                if (location != null) {
                  print(location
                      .fullAddress); // "12 Allen Ave, Ikeja, Lagos, Nigeria"
                  print(location.latitude); // 6.5944
                  print(location.longitude); // 3.3583
                  print(location.state); // "Lagos"
                  print(location.city); // "Ikeja"

                  Get.defaultDialog(
                    title: 'Location Detected',
                    content: Text(
                        'We detected your location as:\n\n${location.fullAddress}\n\nDo you want to use this address for delivery?',
                        textAlign: TextAlign.center),
                    textConfirm: 'Yes, Use This Location',
                    textCancel: 'No, Enter Manually',
                    onConfirm: () async {
                      Navigator.pop(context); // Close the dialog
                      final pinToken = await showPinVerificationDialog(context);
                      if (pinToken.isEmpty) return;

                      //final success =
                      await checkoutController.createOrder(audio);
                      //if (success && context.mounted) Get.back();
                    },
                    onCancel: () {
                      Navigator.pop(context); // Close the dialog
                      Get.to(() => CheckoutAddressChangeScreen());
                    },
                  );
                }
              }
              // Navigator.pop(context); // Close the dialog
              // final pinToken = await showPinVerificationDialog(context);
              // if (pinToken.isEmpty) return;

              // //final success =
              // await checkoutController.createOrder(audio);
              //  Get.back(); // Close the dialog
            },
            onConfirm: () async {
              Navigator.pop(context); // Close the dialog
              final pinToken = await showPinVerificationDialog(context);
              if (pinToken.isEmpty) return;

              //final success =
              await checkoutController.createOrder(audio);
              //if (success && context.mounted) Get.back();
              //  checkoutController.initializeCheckout(amount);
              // checkoutController.createOrder(audio);
              print('paystack calling here');
            },
          );
          // final pinToken = await showPinVerificationDialog(context);
          // if (pinToken.isEmpty) return;

          // //final success =
          // await checkoutController.createOrder(audio);
          // //if (success && context.mounted) Get.back();
          //  checkoutController.initializeCheckout(amount);
          // checkoutController.createOrder(audio);
          print('paystack calling here');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFFF9800),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Opens the device location settings screen.
  static Future<void> openSettings() => Geolocator.openLocationSettings();
}
