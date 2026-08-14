import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'dart:developer' as myLog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_address_change/models/country_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/checkout_screen/atomicWebViewScreen/atomic_webview_screen.dart';
import 'package:jara_market/screens/checkout_screen/location_servies/location_service.dart';
import 'package:jara_market/screens/checkout_screen/models/buildOrderPayload.dart';
import 'package:jara_market/screens/checkout_screen/models/location_model.dart';
import 'package:jara_market/screens/checkout_screen/models/models.dart';
import 'package:jara_market/screens/checkout_screen/models/ordersuccess.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/screens/success_screen/success_screen.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/utils/app_feedback.dart';
import 'package:jara_market/utils/json_helpers.dart';

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
        // Display value only -- the backend re-resolves the delivery fee
        // from the order's address and charges that.
        shippingFee: cartController.shippingCost.value,
        serviceCharge: cartController.calculatedServiceCharge,
        vat: 0,
        remarks: cartController.messageController.text.isNotEmpty ? cartController.messageController.text : 'This is a sample order',
      );

      // `audio` is the local recording's file path (from cart_screen's
      // flutter_sound recorder) -- send it as a real multipart file so the
      // backend actually receives and stores the voice note, instead of
      // just a meaningless on-device path string.
      File? audioFile;
      if (audio != null && audio.isNotEmpty && await File(audio).exists()) {
        audioFile = File(audio);
      }

// Send payload to backend
      var response = await apiService.createOrder(payload, audio: audioFile);
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
      AppFeedback.showError(e,
          fallback: 'We couldn\'t place your order. Please try again.');
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

  /// Attempts to turn a detected GPS location into a real saved address
  /// (with a backend-assigned id) by matching its country/state/city names
  /// against the app's reference lists, then creating the address.
  ///
  /// Order creation requires a real `address_id` - a detected location on
  /// its own is just free text and can't be used to place an order until
  /// it's saved this way. Returns true and updates [selectedAddressId] on
  /// success; returns false (with no address saved) if any part of the
  /// match fails, so the caller can fall back to manual entry.
  Future<bool> saveDetectedLocationAsAddress(UserLocation location) async {
    try {
      final countryResponse = await _apiService.fetchCountry();
      if (countryResponse.statusCode != 200 &&
          countryResponse.statusCode != 201) {
        return false;
      }
      final countries = countryModelFromJson(countryResponse.body).data ?? [];
      final country =
          findByName(countries, (c) => c.name ?? '', location.country);
      if (country?.id == null) return false;

      final stateResponse = await _apiService.fetchState();
      if (stateResponse.statusCode != 200 &&
          stateResponse.statusCode != 201) {
        return false;
      }
      final states = stateModelFromJson(stateResponse.body).data ?? [];
      final state = findByName(states, (s) => s.name ?? '', location.state);
      if (state?.id == null || state?.name == null) return false;

      final lgaResponse = await _apiService.fetchLgas(state!.name!);
      if (lgaResponse.statusCode != 200 && lgaResponse.statusCode != 201) {
        return false;
      }
      final lgas = lgaModelFromJson(lgaResponse.body).data ?? [];
      final lga = findByName(lgas, (l) => l.name ?? '', location.city);
      if (lga?.id == null) return false;

      final profileController = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
      await profileController.fetchUserProfile();
      final phoneNumber = profileController.data.phoneNumber;
      if (phoneNumber == null || phoneNumber.isEmpty) return false;

      final response = await _apiService.addCheckoutAddress({
        'country_id': country!.id,
        'state_id': state.id,
        'lga_id': lga!.id,
        'contact_address': location.fullAddress,
        'phone_number': phoneNumber,
        'is_default': false,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }

      final addressId = extractIdFromResponse(response.body);
      if (addressId == null) return false;

      selectedAddressId.value = addressId;
      selectedAddress.value = location.fullAddress;
      selectedCountry.value = country.name ?? '';
      selectedState.value = state.name ?? '';
      selectedLga.value = lga.name ?? '';
      // Delivery is priced per location, so re-price against the newly
      // detected address before the order is placed.
      await cartController.loadDeliveryFee(stateId: state.id, lgaId: lga.id);
      return true;
    } catch (e) {
      myLog.log('Failed to auto-save detected location as address: $e',
          name: 'CheckoutController');
      return false;
    }
  }
}
