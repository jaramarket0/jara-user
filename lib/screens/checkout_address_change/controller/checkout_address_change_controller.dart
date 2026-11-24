import 'dart:async';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_address_change/models/country_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/checkout_screen/location_servies/location_service.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/screens/address_map_picker/address_map_picker_screen.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/services/osm_geocoding_service.dart';
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

  /// The point the customer confirmed, either by picking a suggestion or by
  /// dropping a pin. Null means we still have to work it out from the text.
  final Rx<OsmPlace?> pickedPlace = Rx<OsmPlace?>(null);
  final RxList<OsmPlace> suggestions = <OsmPlace>[].obs;
  final RxBool isGeocoding = false.obs;
  Timer? _suggestDebounce;

  @override
  void onInit() {
    super.onInit();
    myLog.log('CheckoutAddressChangeController initialized');
    // Editing the text after confirming a point would otherwise ship the old
    // coordinates with the new address -- the rider goes to the last place.
    contactAddressController.addListener(_onAddressTextChanged);
  }

  @override
  void onClose() {
    _suggestDebounce?.cancel();
    contactAddressController.removeListener(_onAddressTextChanged);
    super.onClose();
  }

  String _lastSuggestQuery = '';

  void _onAddressTextChanged() {
    final text = contactAddressController.text.trim();
    final picked = pickedPlace.value;
    if (picked != null && text != _acceptedText) {
      pickedPlace.value = null;
    }
    if (text == _lastSuggestQuery) return;
    _lastSuggestQuery = text;
    _suggestDebounce?.cancel();
    if (text.length < 3) {
      suggestions.clear();
      return;
    }
    // Typing is bursty and Nominatim allows one call a second, so wait for a
    // pause rather than racing the keyboard.
    _suggestDebounce = Timer(const Duration(milliseconds: 650), () async {
      final results = await OsmGeocodingService.search(
          text, state: selectedState1, lga: selectedLGA1);
      // A later keystroke may have superseded this lookup while it was out.
      if (text != contactAddressController.text.trim()) return;
      suggestions.assignAll(results);
    });
  }

  /// The text that belongs to [pickedPlace], so edits can be detected.
  String _acceptedText = '';

  void acceptSuggestion(OsmPlace place) {
    final label = [place.title, place.subtitle]
        .where((p) => p.isNotEmpty)
        .join(', ');
    _acceptedText = label;
    _lastSuggestQuery = label;
    contactAddressController.text = label;
    pickedPlace.value = place;
    suggestions.clear();
  }

  /// Opens the map so the customer can place the pin exactly. Pre-centred on
  /// whatever we already know, so they adjust rather than start from nothing.
  Future<void> openMapPicker() async {
    OsmPlace? start = pickedPlace.value;
    if (start == null) {
      isGeocoding.value = true;
      start = await _geocodeFromFields();
      isGeocoding.value = false;
    }
    final result = await Get.to(() => const AddressMapPickerScreen(),
        arguments: {
          'latitude': start?.latitude,
          'longitude': start?.longitude,
        });
    if (result is OsmPlace) {
      pickedPlace.value = result;
      if (contactAddressController.text.trim().isEmpty) {
        _acceptedText = result.title;
        _lastSuggestQuery = result.title;
        contactAddressController.text = result.title;
      } else {
        // Keep what they typed -- it often has a landmark or flat number that
        // no map knows -- but treat it as matching the confirmed pin.
        _acceptedText = contactAddressController.text;
      }
      suggestions.clear();
    }
  }

  /// True when a point is specific enough to deliver to. A result with no
  /// road is a town or LGA centroid -- it will geocode happily and send the
  /// rider to the middle of a district.
  static bool _isStreetLevel(OsmPlace p) =>
      p.road.isNotEmpty || p.houseNumber.isNotEmpty;

  /// Best effort at a point from the typed fields alone, in descending order
  /// of precision. OpenStreetMap first and the platform geocoder last: the
  /// latter is a different service on every device, so it is a safety net
  /// rather than a source of truth.
  Future<OsmPlace?> _geocodeFromFields() async {
    final typed = contactAddressController.text.trim();

    if (typed.isNotEmpty) {
      final hits = await OsmGeocodingService.search(
          typed, state: selectedState1, lga: selectedLGA1, limit: 1);
      if (hits.isNotEmpty) return hits.first;

      final structured = await OsmGeocodingService.searchStructured(
          street: typed, county: selectedLGA1, state: selectedState1);
      if (structured != null) return structured;
    }

    // Platform geocoder, for the addresses OSM has no record of.
    final platform = await LocationService.forwardGeocode(
        [typed, selectedLGA1, selectedState1, 'Nigeria']
            .where((p) => p != null && p.toString().trim().isNotEmpty)
            .join(', '));
    if (platform != null) {
      return OsmPlace(
        latitude: platform.latitude,
        longitude: platform.longitude,
        displayName: typed,
        // Unknown precision, so don't claim street level.
      );
    }

    // Last resort: the LGA itself. Deliberately not street level, so the
    // caller asks the customer to place the pin instead of shipping this.
    return OsmGeocodingService.searchStructured(
        county: selectedLGA1, state: selectedState1);
  }

  /// The backend requires latitude/longitude on every address, and the rider
  /// needs them to be right. Order: the point the customer confirmed, then
  /// geocoding, and a coarse hit is reported as such rather than saved.
  Future<Map<String, double>?> _resolveCoordinates() async {
    final confirmed = pickedPlace.value;
    if (confirmed != null) {
      return {
        'latitude': confirmed.latitude,
        'longitude': confirmed.longitude,
      };
    }

    final found = await _geocodeFromFields();
    if (found == null) return null;

    if (!_isStreetLevel(found)) {
      // Centroid-grade. Saving it silently is how an order ends up pinned to
      // the middle of an LGA, so hand it back for confirmation on the map.
      coarseResult.value = found;
      return null;
    }

    pickedPlace.value = found;
    _acceptedText = contactAddressController.text;
    return {'latitude': found.latitude, 'longitude': found.longitude};
  }

  /// Set when geocoding could only place the address approximately. The
  /// screen uses it to send the customer to the map instead of showing a
  /// dead-end error.
  final Rx<OsmPlace?> coarseResult = Rx<OsmPlace?>(null);

  /// Resolve, and if the answer is too vague, let the customer pin it.
  /// Returns true once there is a point precise enough to save.
  Future<bool> ensurePreciseLocation() async {
    if (pickedPlace.value != null) return true;
    isGeocoding.value = true;
    final coords = await _resolveCoordinates();
    isGeocoding.value = false;
    if (coords != null) return true;

    final coarse = coarseResult.value;
    coarseResult.value = null;
    final confirmed = await Get.dialog<bool>(AlertDialog(
      title: const Text('Pin your exact location',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
      content: Text(
        coarse == null
            ? 'We couldn\'t find that address. Point it out on the map so '
                'your rider knows where to come.'
            : 'We could only narrow that address down to the general area. '
                'Drop a pin so your rider comes to the right place.',
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      ),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Open map',
                style: TextStyle(fontWeight: FontWeight.w600))),
      ],
    ));
    if (confirmed != true) return false;

    if (coarse != null) pickedPlace.value = coarse; // centres the map there
    await openMapPicker();
    // openMapPicker leaves pickedPlace as the coarse seed if the customer
    // backed out without confirming, so require a real confirmation.
    return pickedPlace.value != null && pickedPlace.value != coarse;
  }

  isValid() {
    return selectedStateId != null &&
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
  if (isValid()) {
    // Settle the location first: this can open a dialog or the map, neither
    // of which belongs underneath a blocking loading overlay.
    if (!await ensurePreciseLocation()) return {};
    final place = pickedPlace.value!;
    final coordinates = {
      'latitude': place.latitude,
      'longitude': place.longitude,
    };

    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    isLoading.value = true;

    final Map<String, dynamic> addressData = {
      'country_id': selectedCountryId,
      'state_id': selectedStateId,
      'lga_id': selectedLGAId,
      'contact_address': contactAddressController.text,
      'phone_number': contactNumberController.text,
      'is_default': isDefault.value,
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
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
    AppFeedback.showError(null,
        fallback: 'Please select a state and LGA.');
    return {};
  }
}


  Future<Map<dynamic, dynamic>> storeAddress() async {
    if (!await ensurePreciseLocation()) return {};
    final place = pickedPlace.value!;
    final coordinates = {
      'latitude': place.latitude,
      'longitude': place.longitude,
    };

    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    final Map<String, dynamic> addressData = {
      'country_id': selectedCountryId,
      'state_id': selectedStateId,
      'lga_id': selectedLGAId,
      'contact_address': contactAddressController.text,
      'phone_number': contactNumberController.text,
      'is_default': isDefault.value,
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
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
