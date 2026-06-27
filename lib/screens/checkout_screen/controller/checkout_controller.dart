import 'dart:convert';

import 'package:intl/intl.dart';
import 'dart:developer' as myLog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_screen/atomicWebViewScreen/atomic_webview_screen.dart';
import 'package:jara_market/screens/checkout_screen/location_servies/location_service.dart';
import 'package:jara_market/screens/checkout_screen/models/buildOrderPayload.dart';
import 'package:jara_market/screens/checkout_screen/models/location_model.dart';
import 'package:jara_market/screens/checkout_screen/models/models.dart';
import 'package:jara_market/screens/checkout_screen/models/ordersuccess.dart';
import 'package:jara_market/screens/success_screen/success_screen.dart';
import 'package:jara_market/services/api_service.dart';

class CheckoutController extends GetxController {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  RxString selectedAddress = ''.obs;
  RxString selectedLga = ''.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedState = ''.obs;
  RxString number = ''.obs;
  RxString address = ''.obs;
  RxString contactName = ''.obs;
  RxBool isDefault = false.obs;
  RxBool isLoading = false.obs;
  RxInt selectedAddressId = 0.obs;
  OrderSuccessModel orderSuccessModel = OrderSuccessModel();
  CheckoutModel checkoutModel = CheckoutModel(
    status: false,
    message: '',
    data: Data(url: ''),
  );
  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void updateAddress(String newAddress) {
    selectedAddress.value = newAddress;
  }

  void updateLga(String newLga) {
    selectedLga.value = newLga;
  }

  void updateCountry(String newCountry) {
    selectedCountry.value = newCountry;
  }

  void updateState(String newState) {
    selectedState.value = newState;
  }

  void updateNumber(String newNumber) {
    number.value = newNumber;
  }

  void updateContactName(String newName) {
    contactName.value = newName;
  }

  void toggleDefault() {
    isDefault.value = !isDefault.value;
  }

  Future<void> initializeCheckout(double amount) async {
    isLoading.value = true;
    print('Initializing checkout with amount: $amount');
    try {
      var checkoutData = {
        "amount": amount,
        "currency": "NGN",
        "callback_url": "http://127.0.0.1:8000",
        "metadata": {"notes": "This is a sample payment"},
        "payment_gateway": "paystack"
      };
      var response = await _apiService.getCheckoutData(checkoutData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        // Handle successful response
        checkoutModel = checkoutModelFromJson(response.body);
        print('Checkout initialized successfully: ${checkoutModel.data?.url}');
        Navigator.push(
          Get.context!,
          CupertinoPageRoute(
            builder: (context) => AtomicWebViewScreen(
              url: checkoutModel.data?.url ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error initializing checkout: $e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  CartController cartController = Get.find<CartController>();

  Future<void> createOrder(String? audio) async {
    isLoading.value = true;

    try {
      final payload = 
//       {
//     "order_date": "2025-06-02",
//     "shipping_fee": "0",
//     "delivery_type": "pickup", //or walkin
//     "address_id": 1,
//     "service_charge": 1000,
//     "products": [
//         {
//                 "product_id": 7,
//                 "quantity": 3,
//                 "price": 4000
//         },
//         {
//                 "product_id": 8,
//                 "quantity": 3,
//                 "price": 4000
//         }
//     ],
//     "ingredients": [
//         {
//             "ingredient_id": 1,
//             "quantity": 2,
//             "unit": "kg",
//             "price": 3000
//         },
//         {
//             "ingredient_id": 4,
//             "quantity": 2,
//             "unit": "kg",
//             "price": 3000
//         }
//     ],
//     "vat": 100,
//     "total": 5000
// };
      buildOrderPayload(
        cartItems: cartController.cartItems,
        ingredient: cartController.ingredientList,
        orderDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        addressId: selectedAddressId.value,
        deliveryType: 'pickup',
        shippingFee: 2000,
        serviceCharge: 1000,
        vat: 0,
        remarks: cartController.messageController.text.isNotEmpty ? cartController.messageController.text : 'This is a sample order',
        audio_url: audio ?? null,
      );

// Send payload to backend
      var response = await apiService.createOrder(payload); // Example API call
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        myLog.log(response.body, name: 'Order body');
        orderSuccessModel = orderSuccessModelFromJson(response.body);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(orderSuccessModel.message.toString()),
          backgroundColor: Colors.green,
        ));
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (context) => SuccessScreen()),
          (route) => false,
        );
      } else {
        myLog.log('Order failed ${response.statusCode}: ${response.body}', name: 'CheckoutController');
        final msg = jsonDecode(response.body)['message'] ?? 'Something went wrong';
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      myLog.log('Order exception: $e', name: 'CheckoutController');
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      isLoading.value = false;
    }
  }



  Rx<UserLocation?> currentLocation = Rx<UserLocation?>(null);
  
  RxString error = ''.obs;
 
  /// Detect location and store it reactively.
  Future<void> detectLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        currentLocation.value = location;
      } else {
        error.value = 'Could not detect location.';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
      Get.snackbar('Error', error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
 
  /// Convenience getters
  double? get latitude => currentLocation.value?.latitude;
  double? get longitude => currentLocation.value?.longitude;
  String get fullAddress => currentLocation.value?.fullAddress ?? '';
  bool get hasLocation => currentLocation.value != null;
}
