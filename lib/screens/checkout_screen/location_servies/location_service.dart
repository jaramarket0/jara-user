import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:jara_market/screens/checkout_screen/models/location_model.dart';

class LocationService {
  /// Returns the current [UserLocation] or null if permission denied / error.
  static Future<UserLocation?> getCurrentLocation() async {
    // 1. Check if location services are enabled on the device
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.defaultDialog(
        title: 'Location Disabled',
        content: Text(
            'Please turn on location services in your device settings.',
            textAlign: TextAlign.center),
        //backgroundColor: Colors.orange,
        confirm: TextButton(
          onPressed: () {
            Navigator.pop(Get.context!);
            Geolocator.openLocationSettings();
            Navigator.pop(Get.context!);
          },
          child: const Text('Open Settings',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ),
        // colorText: Colors.white,
        // snackPosition: SnackPosition.BOTTOM,
        // duration: const Duration(seconds: 4),
      );
      return null;
    }

    // 2. Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is required to auto-fill your address.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Permanently Denied',
        'Enable location in your device settings to use this feature.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => Geolocator.openAppSettings(),
          child: const Text('Open Settings',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
      return null;
    }

    // 3. Get GPS position
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4. Reverse-geocode to a readable address
    return _reverseGeocode(position);
  }

  /// Converts [Position] → [UserLocation] via reverse geocoding.
  static Future<UserLocation?> _reverseGeocode(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      final p = placemarks.first;

      // Build a clean full address from non-empty parts
      final parts = <String>[
        if ((p.street ?? '').isNotEmpty) p.street!,
        if ((p.subLocality ?? '').isNotEmpty) p.subLocality!,
        if ((p.locality ?? '').isNotEmpty) p.locality!,
        if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea!,
        if ((p.country ?? '').isNotEmpty) p.country!,
      ];

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        fullAddress: parts.join(', '),
        street: p.street ?? '',
        city: p.subLocality?.isNotEmpty == true
            ? p.subLocality!
            : p.locality ?? '',
        state: p.administrativeArea ?? '',
        country: p.country ?? '',
        postalCode: p.postalCode ?? '',
      );
    } catch (e) {
      Get.snackbar(
        'Address Error',
        'Could not resolve an address for your location.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// One-time check: returns true if we already have permission.
  static Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Opens the device location settings screen.
  static Future<void> openSettings() => Geolocator.openLocationSettings();
}
