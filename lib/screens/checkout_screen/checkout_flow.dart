// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jara_market/screens/checkout_screen/checkout_screen.dart';
// import 'package:jara_market/screens/checkout_screen/order_receipt_screen.dart';
// import 'package:jara_market/screens/profile_screen/pinScreen.dart';
// import 'package:jara_market/services/api_service.dart';
// // import 'package:jara_market/screens/pin_screen/pin_screen.dart';
// // import 'package:jara_market/screens/receipt_screen/order_receipt_screen.dart';
// // import 'package:jara_market/screens/checkout_address_screen/checkout_address_screen.dart';
// import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
// import 'package:jara_market/screens/cart_screen/models/models.dart';

// // ─── Controller ──────────────────────────────────────────────────────────────

// class CheckoutController extends GetxController {
//   final ApiService _api = ApiService(const Duration(seconds: 60));

//   RxBool isLoading = false.obs;
//   Rx<OrderReceipt?> lastReceipt = Rx<OrderReceipt?>(null);

//   /// Full checkout flow:
//   /// 1. Show PIN verification dialog
//   /// 2. If PIN passes, create order
//   /// 3. Navigate to receipt screen
//   Future<void> startCheckout({
//     required BuildContext context,
//     required CartController cartCtrl,
//     File? audioFile,
//   }) async {
//     // Step 1 – verify PIN
//     final pinToken = await showPinVerificationDialog(context);
//     if (pinToken.isEmpty) return; // user cancelled

//     // Step 2 – get selected address
//     final addrCtrl = Get.isRegistered<DeliveryAddressController>()
//         ? Get.find<DeliveryAddressController>()
//         : Get.put(DeliveryAddressController());
//     final address = addrCtrl.selected.value;

//     // if (address == null) {
//     //   // Get.snackbar(
//     //   //   'No Address',
//     //   //   'Please select a delivery address before checking out.',
//     //   //   backgroundColor: Colors.red,
//     //   //   colorText: Colors.white,
//     //   //   snackPosition: SnackPosition.BOTTOM,
//     //   // );
//     //   Get.defaultDialog(
//     //     title: 'No Address Selected',
//     //     middleText: 'Please select a delivery address before checking out.',
//     //     textConfirm: 'OK',
//     //     onConfirm: () => Navigator.pop(context), //Get.back(),
//     //   );
//     //   return;
//     // }

//     isLoading.value = true;

//     try {
//       // Build order payload
//       final products = cartCtrl.cartItems
//           .map((item) => {
//                 'product_id': item.id,
//                 'quantity': item.quantity.value,
//                 'price': item.price,
//               })
//           .toList();

//       final ingredients = cartCtrl.ingredientList
//           .map((ing) => {
//                 'ingredient_id': ing.id,
//                 'quantity': ing.quantity?.value ?? 1,
//                 'unit': ing.unit ?? 'pcs',
//                 'price': ing.price ?? 0,
//               })
//           .toList();

//       final serviceCharge = cartCtrl.calculatedServiceCharge +
//           cartCtrl.calculatedServiceChargeForIngredient;

//       final orderData = {
//         'order_date': DateTime.now().toIso8601String().split('T').first,
//         'shipping_fee': cartCtrl.shippingCost.value.toInt(),
//         'delivery_type': 'delivery',
//         'address_id': address.id ?? ,
//         'service_charge': serviceCharge.toInt(),
//         'vat': (cartCtrl.total * 0.01).toInt(), // 1% VAT estimate
//         'total': cartCtrl.total.toInt(),
//         'remarks': cartCtrl.messageController.text.trim(),
//         'products': jsonEncode(products),
//         'ingredients': jsonEncode(ingredients),
//       };

//       final res = await _api.createOrder(orderData, audio: audioFile);
//       final body = jsonDecode(res.body);

//       if (res.statusCode == 200 || res.statusCode == 201) {
//         // Build receipt
//         final receipt = _buildReceipt(body, cartCtrl, address);
//         lastReceipt.value = receipt;

//         // Clear cart
//         cartCtrl.clearCart();
//         cartCtrl.deleteIngredientList();

//         // Navigate to receipt
//         Get.off(() => OrderReceiptScreen(receipt: receipt));
//       } else {
//         Get.snackbar(
//           'Order Failed',
//           body['message'] ?? 'Could not place order. Please try again.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       // Get.snackbar(
//       //   'Error',
//       //   'Network error. Please check your connection and try again.',
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//       Get.defaultDialog(
//         title: 'Error',
//         middleText:
//             'Network error. Please check your connection and try again. $e',
//         textConfirm: 'OK',
//         onConfirm: () => Navigator.pop(context), //Get.back(),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   OrderReceipt _buildReceipt(
//     Map<String, dynamic> responseBody,
//     CartController cartCtrl,
//     DeliveryAddress address,
//   ) {
//     // If the API returns the full order data, parse it
//     if (responseBody['data'] != null) {
//       return OrderReceipt.fromJson(responseBody);
//     }

//     // Otherwise build from local cart state
//     final items = cartCtrl.cartItems
//         .map((item) => ReceiptItem(
//               name: item.name,
//               quantity: item.quantity.value,
//               price: item.price,
//             ))
//         .toList();

//     final ingredientItems = cartCtrl.ingredientList
//         .map((ing) => ReceiptItem(
//               name: ing.name ?? '',
//               quantity: ing.quantity?.value ?? 1,
//               price: ing.price ?? 0,
//               unit: ing.unit,
//             ))
//         .toList();

//     return OrderReceipt(
//       orderId: responseBody['data']?['id']?.toString() ??
//           responseBody['order_id']?.toString() ??
//           DateTime.now().millisecondsSinceEpoch.toString(),
//       orderDate: DateTime.now().toIso8601String(),
//       items: items,
//       ingredients: ingredientItems,
//       subTotal: cartCtrl.totalIngredientPrice.value,
//       serviceCharge: cartCtrl.calculatedServiceCharge +
//           cartCtrl.calculatedServiceChargeForIngredient,
//       shippingFee: cartCtrl.shippingCost.value,
//       vat: cartCtrl.total * 0.01,
//       total: cartCtrl.total,
//       deliveryAddress: address.contactAddress ?? '',
//       paymentMethod: 'Wallet',
//       status: responseBody['data']?['status']?.toString() ?? 'Confirmed',
//     );
//   }
// }

// // ─── Checkout Button (drop-in replacement for the existing CheckoutButton widget)

// class CheckoutButtonWithPin extends StatelessWidget {
//   final bool isEnabled;
//   final double totalAmount;
//   final List<CartItem> cartItems;
//   final bool loading;
//   final String? path; // audio recording path

//   const CheckoutButtonWithPin({
//     Key? key,
//     required this.isEnabled,
//     required this.totalAmount,
//     required this.cartItems,
//     this.loading = false,
//     this.path,
//   }) : super(key: key);

//   String _formatAmount(double amount) {
//     return '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final checkoutCtrl = Get.put(CheckoutController());
//     final cartCtrl = Get.find<CartController>();

//     return Obx(() {
//       final isProcessing = checkoutCtrl.isLoading.value || loading;
//       return SizedBox(
//         width: double.infinity,
//         height: 56,
//         child: ElevatedButton(
//           onPressed: (isEnabled && !isProcessing)
//               ? () async {
//                   File? audioFile;
//                   if (path != null && path!.isNotEmpty) {
//                     audioFile = File(path!);
//                     if (!await audioFile.exists()) audioFile = null;
//                   }
//                   await checkoutCtrl.startCheckout(
//                     context: context,
//                     cartCtrl: cartCtrl,
//                     audioFile: audioFile,
//                   );
//                 }
//               : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFFFAA00),
//             disabledBackgroundColor: const Color(0xFFFFAA00).withOpacity(0.4),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 0,
//           ),
//           child: isProcessing
//               ? const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                           color: Colors.white, strokeWidth: 2.5),
//                     ),
//                     SizedBox(width: 10),
//                     Text('Processing...',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 15)),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.lock_rounded,
//                         color: Colors.white, size: 18),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Checkout  •  ${_formatAmount(totalAmount)}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       );
//     });
//   }
// }
