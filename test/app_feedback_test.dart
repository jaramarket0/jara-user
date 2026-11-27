import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jara_market/utils/app_feedback.dart';

void main() {
  group('friendlyMessage never shows machine output', () {
    const cases = {
      'Failed to load states: {"status":false,"message":"boom"}':
          'Failed to load states.',
      'An error occurred: Exception: Connection closed':
          'An error occurred.',
      '{"status":false,"message":"Insufficient balance"}':
          'Something went wrong. Please try again.',
      '<html><body>502 Bad Gateway</body></html>':
          'Something went wrong. Please try again.',
      "type 'Null' is not a subtype of type 'String'":
          'Something went wrong. Please try again.',
      '#0 main (file:///app/lib/main.dart:10)':
          'Something went wrong. Please try again.',
      // A genuinely human message must survive untouched.
      'Please check the details you entered and try again.':
          'Please check the details you entered and try again.',
    };
    cases.forEach((input, expected) {
      test(input.length > 40 ? '${input.substring(0, 40)}…' : input, () {
        expect(AppFeedback.friendlyMessage(null, fallback: input), expected);
      });
    });
  });

  group('messageFromResponse', () {
    test('prefers the server message', () {
      final r = http.Response('{"status":false,"message":"Wallet balance too low"}', 400);
      expect(AppFeedback.messageFromResponse(r), 'Wallet balance too low');
    });

    test('ignores a server message that is itself raw data', () {
      final r = http.Response('{"message":"{\\"a\\":1}"}', 400);
      expect(AppFeedback.messageFromResponse(r),
          'Please check the details you entered and try again.');
    });

    test('uses the status code when the body is HTML', () {
      final r = http.Response('<html>502</html>', 502);
      expect(AppFeedback.messageFromResponse(r),
          "We're having trouble on our end. Please try again shortly.");
    });

    test('401 explains the session rather than the status', () {
      final r = http.Response('', 401);
      expect(AppFeedback.messageFromResponse(r),
          'Your session has expired. Please log in again.');
    });

    test('falls back to the caller text on an unmapped status', () {
      final r = http.Response('', 418);
      expect(AppFeedback.messageFromResponse(r, fallback: 'Could not save.'),
          'Could not save.');
    });
  });
}
