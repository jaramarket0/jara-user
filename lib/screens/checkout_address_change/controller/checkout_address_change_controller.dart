import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_address_change/models/country_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/utils/app_feedback.dart';
import 'package:jara_market/utils/json_helpers.dart';
import 'package:overlay_kit/overlay_kit.dart';

class CheckoutAddressChangeController extends GetxController {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  CountryData? selectedCountry;
  String? selectedCountry1;
  int? selectedCountryId;
  StateData? selectedState;
  String? selectedState1;
  int? selectedStateId;
  LgaData? selectedLGA;
  String? selectedLGA1;
  int? selectedLGAId;
  RxBool isDefault = false.obs;
  TextEditingController contactAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  List<String> countries = [];
  CountryModel countryModel = CountryModel();
  CountryData selectedCountryData = CountryData();
  List<CountryData> countryDataList = [];
  StateModel stateModel = StateModel();
  StateData selectedStateData = StateData();
  List<StateData> stateDataList = [];
  LgaModel lgaModel = LgaModel();
  LgaData selectedLGAData = LgaData();
  List<LgaData> lgaDataList = [];
  List<String> states = [];
  List<String> lgas = [];

  @override
  void onInit() {
    super.onInit();
    myLog.log('CheckoutAddressChangeController initialized');
    fetchCountries();
    // fetchStates();
    // fetchLgas('Lagos');
  }

  isValid() {
    return selectedCountryId != null &&
        selectedStateId != null &&
        selectedLGAId != null &&
        contactAddressController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty;
  }

  RxBool isLoading = false.obs;
  RxBool isCountryLoading = false.obs;
  RxBool isStateLoading = false.obs;
  RxBool isLgaLoading = false.obs;

  fetchCountries() async {
    isCountryLoading.value = true;

    final response = await _apiService.fetchCountry();
    if (response.statusCode == 200 || response.statusCode == 201) {
      countryModel = countryModelFromJson(response.body);
      countries = countryModel.data!.map((e) => e.name!).toList();
      countryDataList = countryModel.data!;
      isCountryLoading.value = false;
      myLog.log(
          'Countries fetched successfully: ${countries.length} countries loaded.');
      myLog.log('Countries: ${countries.join(', ')}');
    } else {
      isCountryLoading.value = false;
      AppFeedback.showError(null,
          fallback: 'Failed to load countries: ${response.body}');
    }
  }

  fetchStates() async {
    isStateLoading.value = true;

    final response = await _apiService.fetchState();
    if (response.statusCode == 200 || response.statusCode == 201) {
      stateModel = stateModelFromJson(response.body);
      states = stateModel.data!.map((e) => e.name!).toList();
      stateDataList = stateModel.data!;
      isStateLoading.value = false;
      myLog.log('States fetched successfully: ${states.length} states loaded.');
      myLog.log('States: ${states.join(', ')}');
    } else {
      isStateLoading.value = false;
      AppFeedback.showError(null,
          fallback: 'Failed to load states: ${response.body}');
    }
  }

  fetchLgas(String name) async {
    isLgaLoading.value = true;

    final response = await _apiService.fetchLgas(name);
    if (response.statusCode == 200 || response.statusCode == 201) {
      lgaModel = lgaModelFromJson(response.body);
      lgas = lgaModel.data!.map((e) => e.name!).toList();
      lgaDataList = lgaModel.data!;
      isLgaLoading.value = false;
      myLog.log('LGAs fetched successfully: ${lgas.length} LGAs loaded.');
      myLog.log('LGAs: ${lgas.join(', ')}');
    } else {
      isLgaLoading.value = false;
      AppFeedback.showError(null,
          fallback: 'Failed to load LGAs: ${response.body}');
      myLog.log('Failed to load LGAs: ${response.body}');
    }
  }

 Future<Map<dynamic, dynamic>> processUpdateCheckoutAddress() async {
  OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
  if (isValid()) {
    isLoading.value = true;

    final Map<String, dynamic> addressData = {
      'country_id': selectedCountryId,
      'state_id': selectedStateId,
      'lga_id': selectedLGAId,
      'contact_address': contactAddressController.text,
      'phone_number': contactNumberController.text,
      'is_default': isDefault.value,
    };

    myLog.log('Updating address data: $addressData');

    try {
      final response = await _apiService.addCheckoutAddress(addressData);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        myLog.log('Address updated successfully: ${response.body}');
        AppFeedback.showSuccess('Address updated successfully.');

        final addressId = extractIdFromResponse(response.body);
        final contactAddressText = contactAddressController.text;
        final phoneNumberText = contactNumberController.text;
        contactAddressController.text = '';
        contactNumberController.text = '';
        var result = {
          'id': addressId,
          'country': selectedCountry1,
          'state': selectedState1,
          'lga': selectedLGA1,
          'contact_address': contactAddressText,
          'phone_number': phoneNumberText,
          'is_default': isDefault.value.toString(),
        };
        return result;
      } else {
        OverlayLoadingProgress.stop();
        AppFeedback.showError(null,
            fallback: 'Failed to update address: ${response.body}');
        return {};
      }
    } catch (error) {
      OverlayLoadingProgress.stop();
      isLoading.value = false;
      AppFeedback.showError(error, fallback: 'An error occurred: $error');
      return {};
    }
  } else {
    OverlayLoadingProgress.stop();
    AppFeedback.showError(null,
        fallback: 'Please select a country, state, and LGA.');
    return {};
  }
}


  Future<Map<dynamic, dynamic>> storeAddress() async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    final Map<String, dynamic> addressData = {
      'country_id': selectedCountryId,
      'state_id': selectedStateId,
      'lga_id': selectedLGAId,
      'contact_address': contactAddressController.text,
      'phone_number': contactNumberController.text,
      'is_default': isDefault.value,
    };

    myLog.log('Storing address data: $addressData');

    try {
      final response = await _apiService.addCheckoutAddress(addressData);
      OverlayLoadingProgress.stop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        myLog.log('Address stored successfully: ${response.body}');
        AppFeedback.showSuccess('Address stored successfully.');

        final addressId = extractIdFromResponse(response.body);
        var result = {
          'id': addressId,
          'country': selectedCountry1,
          'state': selectedState1,
          'lga': selectedLGA1,
          'contact_address': contactAddressController.text,
          'phone_number': contactNumberController.text,
          'is_default': isDefault.value.toString(),
        };

        Future.delayed(Duration(milliseconds: 100), () {
          profileController.fetchUserProfile();
        });

        return result;
      } else {
        debugPrint(
            'Failed to store address (${response.statusCode}): ${response.body}');
        AppFeedback.showError(null,
            fallback: 'Failed to store address: ${response.body}');
        return {};
      }
    } catch (error) {
      OverlayLoadingProgress.stop();
      AppFeedback.showError(error,
          fallback: 'An error occurred while storing address: $error');
      return {};
    }
  }
}
