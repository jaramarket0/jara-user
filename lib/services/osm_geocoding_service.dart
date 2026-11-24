import 'dart:async';
import 'dart:convert';
import 'dart:developer' as myLog;

import 'package:http/http.dart' as http;

/// One result from Nominatim, flattened to the parts an address form needs.
class OsmPlace {
  final double latitude;
  final double longitude;
  final String displayName;
  final String road;
  final String houseNumber;
  final String suburb;
  final String city;
  final String lga;
  final String state;
  final String postcode;

  /// Nominatim's own confidence, 0..1. Useful for ordering, not for deciding:
  /// a low-importance result can still be the exact house the customer meant.
  final double importance;

  const OsmPlace({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    this.road = '',
    this.houseNumber = '',
    this.suburb = '',
    this.city = '',
    this.lga = '',
    this.state = '',
    this.postcode = '',
    this.importance = 0,
  });

  /// The short form for a suggestion row: the street line, without the
  /// "Nigeria" tail that every result shares and nobody reads.
  String get title {
    final street = [houseNumber, road].where((p) => p.isNotEmpty).join(' ');
    if (street.isNotEmpty) return street;
    return displayName.split(',').first.trim();
  }

  /// The context line under the title: enough to tell two same-named streets
  /// apart, which is the whole point of showing suggestions.
  String get subtitle {
    final parts = [suburb, city, lga, state]
        .where((p) => p.isNotEmpty)
        .toSet() // Nominatim repeats the same name across fields constantly.
        .toList();
    if (parts.isEmpty) return displayName;
    return parts.join(', ');
  }

  factory OsmPlace.fromJson(Map<String, dynamic> json) {
    final a = (json['address'] as Map?)?.cast<String, dynamic>() ?? const {};
    String pick(List<String> keys) {
      for (final k in keys) {
        final v = a[k];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return '';
    }

    return OsmPlace(
      latitude: double.tryParse('${json['lat']}') ?? 0,
      longitude: double.tryParse('${json['lon']}') ?? 0,
      displayName: '${json['display_name'] ?? ''}',
      road: pick(['road', 'pedestrian', 'footway', 'residential']),
      houseNumber: pick(['house_number']),
      suburb: pick(['suburb', 'neighbourhood', 'quarter', 'hamlet']),
      city: pick(['city', 'town', 'village', 'municipality']),
      // Nigerian LGAs come back under county, occasionally city_district.
      lga: pick(['county', 'city_district', 'local_government_area']),
      state: pick(['state', 'region']),
      postcode: pick(['postcode']),
      importance: (json['importance'] is num)
          ? (json['importance'] as num).toDouble()
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'display_name': displayName,
        'road': road,
        'house_number': houseNumber,
        'suburb': suburb,
        'city': city,
        'lga': lga,
        'state': state,
        'postcode': postcode,
      };
}

/// Address lookup against OpenStreetMap's Nominatim.
///
/// Chosen over the platform geocoder because that one is a different service
/// on every device -- unavailable on many Android builds without Play
/// Services, and silently coarse elsewhere -- so the same typed address
/// resolved to different coordinates depending on the customer's phone.
/// Nominatim is one service with one dataset, and it returns house-level
/// results for Nigerian addresses that the platform geocoder rounds to a
/// town centre.
///
/// Nominatim's usage policy caps callers at one request per second and
/// requires identification, both of which are enforced here rather than left
/// to call sites: getting blocked would take address entry down completely.
class OsmGeocodingService {
  static const String _host = 'nominatim.openstreetmap.org';

  /// Identifies this app to Nominatim, as its policy requires. A contactable
  /// URL, deliberately not a personal email address.
  static const String _userAgent =
      'JaraMarket/1.0 (+https://jaramarket.com.ng)';

  static const Duration _minGap = Duration(milliseconds: 1100);
  static DateTime _lastCall = DateTime.fromMillisecondsSinceEpoch(0);

  /// Serialises calls and spaces them out. Without this, a fast typist with
  /// debouncing still bursts several lookups and earns a 429.
  static Future<void> _throttle() async {
    final since = DateTime.now().difference(_lastCall);
    if (since < _minGap) await Future.delayed(_minGap - since);
    _lastCall = DateTime.now();
  }

  static Future<List<dynamic>?> _get(Uri url) async {
    await _throttle();
    try {
      final response = await http.get(url, headers: {
        'User-Agent': _userAgent,
        'Accept': 'application/json',
        // Nigeria is the operating country, so bias the language of results.
        'Accept-Language': 'en',
      }).timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        myLog.log('Nominatim ${response.statusCode}: $url',
            name: 'OsmGeocodingService');
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map<String, dynamic>) return [decoded];
      return null;
    } catch (e) {
      myLog.log('Nominatim failed: $e', name: 'OsmGeocodingService');
      return null;
    }
  }

  /// Free-text search, biased to the state and LGA the customer already
  /// picked. The bias matters a great deal here: "Market Road" exists in most
  /// Nigerian states, and an unbiased search confidently returns the wrong one.
  static Future<List<OsmPlace>> search(
    String query, {
    String? state,
    String? lga,
    int limit = 6,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 3) return const [];

    final context = [trimmed, lga, state, 'Nigeria']
        .where((p) => p != null && p.trim().isNotEmpty)
        .join(', ');

    final url = Uri.https(_host, '/search', {
      'q': context,
      'format': 'jsonv2',
      'addressdetails': '1',
      'countrycodes': 'ng',
      'limit': '$limit',
    });

    final rows = await _get(url);
    if (rows == null) return const [];

    final places = rows
        .whereType<Map<String, dynamic>>()
        .map(OsmPlace.fromJson)
        .where((p) => p.latitude != 0 && p.longitude != 0)
        .toList();

    // Results whose state matches the customer's selection come first: the
    // country-wide search still leaks other states in, and a wrong-state hit
    // at the top of the list is the one mistake that is expensive.
    if (state != null && state.trim().isNotEmpty) {
      final want = state.trim().toLowerCase();
      places.sort((a, b) {
        final am = a.state.toLowerCase().contains(want) ? 0 : 1;
        final bm = b.state.toLowerCase().contains(want) ? 0 : 1;
        if (am != bm) return am - bm;
        return b.importance.compareTo(a.importance);
      });
    }
    return places;
  }

  /// Structured lookup -- the fallback when free text finds nothing. Giving
  /// Nominatim the fields separately lets it match on the parts it trusts
  /// instead of trying to parse one run-on string.
  static Future<OsmPlace?> searchStructured({
    String? street,
    String? city,
    String? county,
    String? state,
  }) async {
    final params = <String, String>{
      'format': 'jsonv2',
      'addressdetails': '1',
      'countrycodes': 'ng',
      'limit': '1',
      'country': 'Nigeria',
    };
    if (street != null && street.trim().isNotEmpty) {
      params['street'] = street.trim();
    }
    if (city != null && city.trim().isNotEmpty) params['city'] = city.trim();
    if (county != null && county.trim().isNotEmpty) {
      params['county'] = county.trim();
    }
    if (state != null && state.trim().isNotEmpty) params['state'] = state.trim();
    if (params.length <= 5) return null; // nothing but the boilerplate

    final rows = await _get(Uri.https(_host, '/search', params));
    if (rows == null || rows.isEmpty) return null;
    final first = rows.first;
    if (first is! Map<String, dynamic>) return null;
    final place = OsmPlace.fromJson(first);
    return (place.latitude == 0 && place.longitude == 0) ? null : place;
  }

  /// Coordinates → address, for the map pin.
  static Future<OsmPlace?> reverse(double latitude, double longitude) async {
    final url = Uri.https(_host, '/reverse', {
      'lat': '$latitude',
      'lon': '$longitude',
      'format': 'jsonv2',
      'addressdetails': '1',
      // 18 is building level; the default rounds to something useless here.
      'zoom': '18',
    });
    final rows = await _get(url);
    if (rows == null || rows.isEmpty) return null;
    final first = rows.first;
    if (first is! Map<String, dynamic>) return null;
    if (first['error'] != null) return null;
    // Reverse results carry no lat/lon of their own worth trusting over the
    // pin the customer placed, so keep theirs.
    final place = OsmPlace.fromJson(first);
    return OsmPlace(
      latitude: latitude,
      longitude: longitude,
      displayName: place.displayName,
      road: place.road,
      houseNumber: place.houseNumber,
      suburb: place.suburb,
      city: place.city,
      lga: place.lga,
      state: place.state,
      postcode: place.postcode,
      importance: place.importance,
    );
  }
}
