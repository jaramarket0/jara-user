import 'dart:developer' as myLog;

import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/services/osm_geocoding_service.dart';

/// A point on the map matched to the state and LGA rows the backend knows.
class ResolvedArea {
  final int stateId;
  final String stateName;
  final int lgaId;
  final String lgaName;
  final double latitude;
  final double longitude;

  const ResolvedArea({
    required this.stateId,
    required this.stateName,
    required this.lgaId,
    required this.lgaName,
    required this.latitude,
    required this.longitude,
  });
}

/// Turns coordinates into the state/LGA ids the API expects.
///
/// The map gives names ("Lagos", "Eti Osa") while every endpoint wants the
/// numeric ids from our own tables, so the two have to be matched by name.
/// That matching is the whole difficulty: OpenStreetMap spells Nigerian
/// places inconsistently -- "Eti-Osa" vs "Eti Osa", "Lagos State" vs
/// "Lagos", "Ikeja LGA" -- so comparing the raw strings finds nothing most
/// of the time. Everything is normalised before comparison, and a failure to
/// match is reported rather than guessed at, because picking the wrong LGA
/// sends an order to the wrong set of markets.
class LocationResolver {
  static final ApiService _api = ApiService(const Duration(seconds: 60));

  /// Cached because the state list never changes within a session and the
  /// picker can be reopened several times.
  static List<StateData>? _states;

  /// Strips everything that differs between the two spellings of the same
  /// place: case, punctuation, and the administrative suffixes OSM adds.
  static String _normalise(String raw) {
    var text = raw.toLowerCase().trim();
    for (final suffix in const [
      'local government area',
      'local government',
      ' state',
      ' lga',
      ' l.g.a',
    ]) {
      text = text.replaceAll(suffix, ' ');
    }
    // Collapse separators so "Eti-Osa", "Eti Osa" and "Eti/Osa" all agree.
    text = text.replaceAll(RegExp(r"[^a-z0-9]+"), ' ').trim();
    return text.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Best match for [candidates] against [target], or null.
  ///
  /// Tried in descending confidence; a token-overlap guess is accepted only
  /// when it is a whole word, so "Ikeja" never matches "Ika".
  static T? _bestMatch<T>(
    String? target,
    List<T> candidates,
    String? Function(T) nameOf,
  ) {
    if (target == null || target.trim().isEmpty || candidates.isEmpty) {
      return null;
    }
    final want = _normalise(target);
    if (want.isEmpty) return null;

    T? exact;
    T? contains;
    T? token;

    for (final candidate in candidates) {
      final name = nameOf(candidate);
      if (name == null || name.trim().isEmpty) continue;
      final have = _normalise(name);
      if (have.isEmpty) continue;

      if (have == want) {
        exact ??= candidate;
        break;
      }
      if (have.contains(want) || want.contains(have)) {
        contains ??= candidate;
        continue;
      }
      final haveWords = have.split(' ').toSet();
      final wantWords = want.split(' ').toSet();
      if (haveWords.intersection(wantWords).isNotEmpty) {
        token ??= candidate;
      }
    }
    return exact ?? contains ?? token;
  }

  static Future<List<StateData>> _loadStates() async {
    if (_states != null) return _states!;
    final response = await _api.fetchState();
    if (response.statusCode != 200 && response.statusCode != 201) {
      myLog.log('State list failed: ${response.statusCode}',
          name: 'LocationResolver');
      return const [];
    }
    _states = stateModelFromJson(response.body).data ?? [];
    return _states!;
  }

  static Future<List<LgaData>> _loadLgas(String stateName) async {
    final response = await _api.fetchLgas(stateName);
    if (response.statusCode != 200 && response.statusCode != 201) {
      myLog.log('LGA list failed for $stateName: ${response.statusCode}',
          name: 'LocationResolver');
      return const [];
    }
    return lgaModelFromJson(response.body).data ?? [];
  }

  /// Why a resolve failed, so the screen can say something useful instead of
  /// a generic error.
  static String lastFailure = '';

  /// Matches [place] to our own state/LGA rows. Null when either cannot be
  /// matched -- see [lastFailure] for which.
  static Future<ResolvedArea?> resolve(OsmPlace place) async {
    lastFailure = '';

    final states = await _loadStates();
    if (states.isEmpty) {
      lastFailure = 'We couldn\'t load our delivery areas. Check your '
          'connection and try again.';
      return null;
    }

    final state = _bestMatch<StateData>(place.state, states, (s) => s.name);
    if (state?.id == null) {
      lastFailure = place.state.isEmpty
          ? 'We couldn\'t tell which state that location is in. Move the pin '
              'closer to a street and try again.'
          : 'We don\'t deliver in ${place.state} yet.';
      return null;
    }

    final lgas = await _loadLgas(state!.name!);
    // OSM files the LGA under county, but on a town-level result it can land
    // in city instead, so both are worth trying before giving up.
    var lga = _bestMatch<LgaData>(place.lga, lgas, (l) => l.name);
    lga ??= _bestMatch<LgaData>(place.city, lgas, (l) => l.name);
    lga ??= _bestMatch<LgaData>(place.suburb, lgas, (l) => l.name);

    if (lga?.id == null) {
      lastFailure = 'We couldn\'t work out the local government area for '
          'that spot in ${state.name}. Pick it manually instead.';
      return null;
    }

    return ResolvedArea(
      stateId: state.id!,
      stateName: state.name!,
      lgaId: lga!.id!,
      lgaName: lga.name!,
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }
}
