import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:jara_market/services/osm_geocoding_service.dart';

/// Drop a pin on the exact spot the rider should come to.
///
/// Geocoding a typed address gets you to the street; it does not get you to
/// the gate. For delivery, the difference is a phone call per order, so the
/// customer gets the final say on the point -- and because they confirm what
/// they see, the coordinates stop being a guess we made on their behalf.
///
/// Returns the confirmed [OsmPlace] via `Get.back(result:)`, or nothing if
/// the customer backs out.
class AddressMapPickerScreen extends StatefulWidget {
  const AddressMapPickerScreen({super.key});

  @override
  State<AddressMapPickerScreen> createState() => _AddressMapPickerScreenState();
}

class _AddressMapPickerScreenState extends State<AddressMapPickerScreen> {
  final MapController _map = MapController();

  /// Falls back to Lagos only when the caller knows nothing -- a map opening
  /// on the middle of the ocean reads as broken.
  static const LatLng _fallback = LatLng(6.5244, 3.3792);

  late LatLng _center;
  OsmPlace? _resolved;
  bool _looking = false;
  bool _locating = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? const {};
    final lat = args['latitude'];
    final lng = args['longitude'];
    _center = (lat is num && lng is num && !(lat == 0 && lng == 0))
        ? LatLng(lat.toDouble(), lng.toDouble())
        : _fallback;
    _resolveLabel(_center);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Reverse-geocodes after the map settles. Firing on every frame of a drag
  /// would hammer Nominatim and get this app blocked.
  void _scheduleResolve(LatLng point) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      _resolveLabel(point);
    });
  }

  Future<void> _resolveLabel(LatLng point) async {
    if (!mounted) return;
    setState(() => _looking = true);
    final place = await OsmGeocodingService.reverse(
        point.latitude, point.longitude);
    if (!mounted) return;
    setState(() {
      _looking = false;
      // Keep the pin wherever the customer left it even if the lookup fails;
      // an un-named point is still a deliverable one.
      _resolved = place ??
          OsmPlace(
            latitude: point.latitude,
            longitude: point.longitude,
            displayName: 'Dropped pin',
          );
    });
  }

  Future<void> _goToMyLocation() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are off.';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw 'Location permission denied.';
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 15));
      final point = LatLng(pos.latitude, pos.longitude);
      _map.move(point, 17);
      setState(() => _center = point);
      _resolveLabel(point);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Couldn\'t get your location. $e'),
        ));
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = _resolved;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Set exact location',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 16,
                    minZoom: 4,
                    maxZoom: 19,
                    onPositionChanged: (camera, hasGesture) {
                      _center = camera.center;
                      if (hasGesture) _scheduleResolve(camera.center);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // Required by the OSM tile policy; an unidentified
                      // client gets rate-limited and then blocked.
                      userAgentPackageName: 'com.jaramarket.app',
                      maxNativeZoom: 19,
                    ),
                  ],
                ),

                // The pin sits dead centre and the map moves under it, which
                // is both easier to aim with one thumb than dragging a marker
                // and impossible to lose off-screen.
                IgnorePointer(
                  child: Padding(
                    // Lift it so the point of the pin, not its middle, marks
                    // the spot the customer is looking at.
                    padding: const EdgeInsets.only(bottom: 36),
                    child: Icon(Icons.location_on,
                        size: 46, color: Colors.red.shade600),
                  ),
                ),

                // OpenStreetMap's licence requires visible attribution.
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    color: Colors.white70,
                    child: const Text('© OpenStreetMap contributors',
                        style: TextStyle(fontSize: 9, color: Colors.black87)),
                  ),
                ),

                Positioned(
                  right: 12,
                  bottom: 16,
                  child: FloatingActionButton.small(
                    heroTag: 'my_location',
                    backgroundColor: Colors.white,
                    onPressed: _locating ? null : _goToMyLocation,
                    child: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place_outlined,
                        size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _looking
                          ? const Text('Finding address…',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.black54))
                          : Text(
                              place?.displayName ?? 'Drag the map to aim',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.black87),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _looking
                        ? null
                        : () {
                            // Always hand back the pin's own coordinates: the
                            // reverse lookup names the point, it doesn't move it.
                            final p = place;
                            Get.back(
                              result: OsmPlace(
                                latitude: _center.latitude,
                                longitude: _center.longitude,
                                displayName: p?.displayName ?? '',
                                road: p?.road ?? '',
                                houseNumber: p?.houseNumber ?? '',
                                suburb: p?.suburb ?? '',
                                city: p?.city ?? '',
                                lga: p?.lga ?? '',
                                state: p?.state ?? '',
                                postcode: p?.postcode ?? '',
                              ),
                            );
                          },
                    child: const Text('Use this location',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
