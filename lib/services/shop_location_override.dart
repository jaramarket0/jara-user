/// Coordinates to send with catalogue requests instead of the signed-in
/// user's own.
///
/// Set while shopping for someone else: the server decides what is visible by
/// distance from the nearest market, so browsing on a friend's behalf has to
/// measure from *their* address, not from wherever the phone happens to be.
///
/// Held in memory on purpose. Someone else's location is not this user's to
/// keep, and persisting it would silently follow them into their next session
/// after they had switched back to shopping for themselves.
///
/// A plain static rather than a GetX dependency so the HTTP layer doesn't
/// have to reach back into a controller to build a URL.
class ShopLocationOverride {
  static double? latitude;
  static double? longitude;

  static bool get isSet => latitude != null && longitude != null;

  static void set(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  static void clear() {
    latitude = null;
    longitude = null;
  }
}
