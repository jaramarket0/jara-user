import 'package:http/http.dart' as http;

/// Wraps [http.Client] so that any authenticated request (one carrying an
/// `Authorization: Bearer` header) which comes back `401` — meaning the
/// backend rejected it as an expired/invalid token or as "User not found"
/// (see api/utils.py::api_exception_handler on the Django side, both cases
/// return 401) — invokes [onUnauthenticated] so the app can clear the local
/// session and route back to the login screen. Requests without an
/// Authorization header (login, register, OTP, forgot-password, ...) are
/// left untouched so their own screens can surface the real error.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient({required this.onUnauthenticated, http.Client? inner})
      : _inner = inner ?? http.Client();

  final http.Client _inner;
  final Future<void> Function() onUnauthenticated;
  static bool _handlingExpiry = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);

    if (response.statusCode == 401 &&
        request.headers.containsKey('Authorization')) {
      _handleExpiredSession();
    }

    return response;
  }

  void _handleExpiredSession() {
    if (_handlingExpiry) return;
    _handlingExpiry = true;
    onUnauthenticated().whenComplete(() => _handlingExpiry = false);
  }
}
