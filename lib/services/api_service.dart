import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Import foundation for kDebugMode
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const API_TIMEOUT_INT_SECONDS = 60 * 5;
const API_TIMEOUT_DURATION = const Duration(seconds: API_TIMEOUT_INT_SECONDS);

class ApiService extends GetConnect {
  Duration timeout = API_TIMEOUT_DURATION;

  ApiService(this.timeout) : super(timeout: timeout);

  //var baseUrl = 'https://jaramarket.elianaeliohotels.com/api/jaram';
  //var baseUrl = 'https://jaramarket.kenjeffy.com/api/jaram';
  // var baseUrl = 'https://jara-market-laravel-backend-production.up.railway.app/api';
  // var baseUrl = 'http://192.168.45.146:8000/jaram';
  var baseUrl = 'https://jaramarket-backend.onrender.com/api/jaram';

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  Future<String?> fn_getCurrentBearerToken() async {
    return await 'dataBase.getToken()';
  }

  fn_generateCacheBuster([int length = 30]) {
    // Define the set of characters to use for the string
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    // Create an instance of Random
    final Random randomizer = Random();

    // Generate the string by randomly selecting characters
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(randomizer.nextInt(chars.length))));
  }

  // Helper function for logging
  void _logRequest(String method, Uri url, {dynamic body}) {
    if (kDebugMode) {
      print('--- API Request ---');
      print('Method: $method');
      print('URL: $url');
      if (body != null) {
        print('Body: ${jsonEncode(body)}');
      }
      print('-------------------');
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      print('--- API Response ---');
      print('Status Code: ${response.statusCode}');
      print('URL: ${response.request?.url}');
      try {
        // Attempt to decode and print if JSON, otherwise print raw body
        final decodedBody = jsonDecode(response.body);
        print('Body: ${jsonEncode(decodedBody)}'); // Pretty print JSON
      } catch (e) {
        print('Body: ${response.body}'); // Print as is if not JSON
      }
      print('--------------------');
    }
  }

  Future<http.Response> _retryRequest(
      Future<http.Response> Function() request) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          rethrow;
        }
        if (kDebugMode) {
          print(
              'Request failed, retrying in ${retryDelay.inSeconds} seconds... (Attempt $attempts of $maxRetries)');
        }
        await Future.delayed(retryDelay);
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }

  // // Register a new user
  // Future<http.Response> registerCustomer(
  //     Map<String, dynamic> customerData) async {
  //   final url = Uri.parse('$baseUrl/registerUser');
  //   _logRequest('POST', url, body: customerData);
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(customerData),
  //   );
  //   _logResponse(response);
  //   return response;
  // }

  Future<http.Response> registerCustomer(
      Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/register');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> resendOtp(Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/resend-otp');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> forgotPassword(
      Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> resetPassword(Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/reset-password');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchCountry() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/country');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  /// send fcm token to backend
  Future<http.Response> sendFcmToken(Map<String, dynamic> replyData) async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/fcm-token');
    _logRequest('POST', url, body: replyData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(replyData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> googleSignIn({
    required String idToken,
    required String role,
    // String? displayName,
    // String? photoUrl,
  }) async {
    final url = Uri.parse('$baseUrl/google-signin');
    _logRequest('POST', url, body: {
      'id_token': idToken,
      'role': role,
      // if (displayName != null) 'display_name': displayName,
      // if (photoUrl != null) 'photo_url': photoUrl,
    });
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_token': idToken,
        'role': role,
        // if (displayName != null) 'display_name': displayName,
        // if (photoUrl != null) 'photo_url': photoUrl,
      }),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchReferal() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/my-referrals');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchTransactions() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchTransaction(int id) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/payments/$id');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchWallet() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/fetch-wallet');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchState() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/states');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchLgas(String name) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/lgas?state=$name');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> createSupportTicket({
    required String subject,
    required String message,
    String? name,
    String? email,
    String? phone,
    File? attachment,
  }) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support');

    _logRequest('POST', url, body: {
      'subject': subject,
      'message': message,
      if (name != null && name.isNotEmpty) 'name': name,
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (attachment != null) 'attachment': attachment.path,
    });

    if (attachment != null) {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['subject'] = subject;
      request.fields['message'] = message;
      if (name != null && name.isNotEmpty) request.fields['name'] = name;
      if (email != null && email.isNotEmpty) request.fields['email'] = email;
      if (phone != null && phone.isNotEmpty) request.fields['phone'] = phone;

      request.files.add(await http.MultipartFile.fromPath(
        'attachment',
        attachment.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(response);
      return response;
    } else {
      final body = {
        'subject': subject,
        'message': message,
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      _logResponse(response);
      return response;
    }
  }

  Future<http.Response> fetchSupportTickets() async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support');
    _logRequest('GET', url);

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchSupportTicket(int id) async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support/$id');
    _logRequest('GET', url);

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _logResponse(response);
    return response;
  }

  Future<http.Response> updateCheckoutAddress(
      Map<String, dynamic> addressData) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/addresses/1');
    _logRequest('PUT', url, body: addressData);
    final response = await http.put(
      url,
      body: jsonEncode(addressData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> addCheckoutAddress(
      Map<String, dynamic> addressData) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/addresses');
    _logRequest('POST', url, body: addressData);
    final response = await http.post(
      url,
      body: jsonEncode(addressData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> getCheckoutAddress() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/addresses');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Validate user signup OTP
  Future<http.Response> validateUserSignupOtp(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Validate user signup Email
  Future<http.Response> validateUserSignupEmail(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-email');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Login user
  Future<http.Response> login(Map<String, dynamic> loginData) async {
    final url = Uri.parse('$baseUrl/login');
    _logRequest('POST', url, body: loginData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginData),
    );
    _logResponse(response);
    return response;
  }

  // Validate user login OTP
  Future<http.Response> validateUserLoginOtp(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Fetch food categories (paginated — 5 categories per page)
  Future<http.Response> fetchFoodCategory(String lgaID, String stateID,
      {int page = 1}) async {
    if (Get.isSnackbarOpen) {
      return Future.error('Snackbar is open');
    }
    var stateId = stateID == '' || stateID == null
        ? dataBase.getStateAddressId()
        : stateID;
    final url = Uri.parse(
        '$baseUrl/fetch/categories-all-products?lga_id=$lgaID&state_id=$stateId&page=$page&per_page=5');

    _logRequest('GET', url);
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    var token = await dataBase.getToken();
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json;',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // Fetch food products
  Future<http.Response> fetchFood() async {
    final url = Uri.parse('$baseUrl/fetch/categories-limit-products');
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // Fetch ingredients
  Future<http.Response> fetchIngredients() async {
    final url = Uri.parse(
        '$baseUrl/fetch/ingredients?lga_id=${await dataBase.getLGAAddressId()}&&state_id=${await dataBase.getStateAddressId()}');
    var token = await dataBase.getToken();
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // // Create order (used in checkout_screen.dart)
  // Future<http.Response> createOrder(Map<String, dynamic> orderData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token') ?? '';
  //   final url = Uri.parse('$baseUrl/orders');
  //   _logRequest('POST', url, body: orderData);
  //   final response = await http.post(
  //     url,
  //     // body: jsonEncode(orderData),
  //     headers: <String, String>{
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(orderData),
  //   );
  //   _logResponse(response);
  //   return response;
  // }

  // Fetch user profile
  Future<http.Response> fetchUserProfile(String email) async {
    final url = Uri.parse('$baseUrl/fetchUserProfile/$email');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Edit user profile
  Future<http.Response> editUserProfile(
      String email, Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/edit-user-profile/$email');
    _logRequest('POST', url, body: profileData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(profileData),
    );
    _logResponse(response);
    return response;
  }

  // Get current user
  Future<http.Response> getUser() async {
    final url = Uri.parse('$baseUrl/fetch-user');
    _logRequest('GET', url);
    //final prefs = await SharedPreferences.getInstance();
    final token = await dataBase.getToken(); //prefs.getString('token');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new order
  Future<http.Response> postOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('POST', url, body: orderData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Get all orders
  Future<http.Response> getOrders() async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Cancel an order
  Future<http.Response> cancelOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/cancel');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get cart by ID
  Future<http.Response> getCart(String cartId) async {
    final url = Uri.parse('$baseUrl/carts/$cartId');
    _logRequest('GET', url);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order by ID
  Future<http.Response> getOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update order by ID
  Future<http.Response> updateOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('PUT', url, body: orderData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Delete order by ID
  Future<http.Response> deleteOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order receipt
  Future<http.Response> getOrderReceipt(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/receipt');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Track order
  Future<http.Response> trackOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/track');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get orders for a specific user
  Future<http.Response> getUserOrders(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new payment
  Future<http.Response> createPayment(Map<String, dynamic> paymentData) async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('POST', url, body: paymentData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(paymentData),
    );
    _logResponse(response);
    return response;
  }

  // Get all payments
  Future<http.Response> getPayments() async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Handle payment callback
  Future<http.Response> handlePaymentCallback(
      Map<String, dynamic> callbackData) async {
    final url = Uri.parse('$baseUrl/payments/callback');
    _logRequest('GET', url); // Assuming GET, adjust if needed
    final response = await http.get(
      url, // Assuming query parameters are handled elsewhere or not needed for logging body
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Fund wallet
  Future<http.Response> fundWallet(Map<String, dynamic> fundData) async {
    final url = Uri.parse('$baseUrl/wallets/fund');
    _logRequest('POST', url, body: fundData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(fundData),
    );
    _logResponse(response);
    return response;
  }

  // Get all franchises
  Future<http.Response> getFranchises() async {
    final url = Uri.parse('$baseUrl/franchises');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get all users
  Future<http.Response> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update a user
  Future<http.Response> updateUser(
      String userId, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('PUT', url, body: userData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a user
  Future<http.Response> deleteUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Toggle user status
  Future<http.Response> toggleUserStatus(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/toggle-status');
    _logRequest('PATCH', url); // Assuming PATCH, adjust if needed
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Add body here if the PATCH request sends data
    );
    _logResponse(response);
    return response;
  }

  // Get all settings
  Future<http.Response> getSettings() async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create or update settings
  Future<http.Response> updateSettings(
      Map<String, dynamic> settingsData) async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest('POST', url,
        body: settingsData); // Assuming POST for create/update
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(settingsData),
    );
    _logResponse(response);
    return response;
  }

  // Get all categories
  Future<http.Response> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new category
  Future<http.Response> createCategory(
      Map<String, dynamic> categoryData) async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('POST', url, body: categoryData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Update a category
  Future<http.Response> updateCategory(
      String categoryId, Map<String, dynamic> categoryData) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('PUT', url, body: categoryData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a category
  Future<http.Response> deleteCategory(String categoryId) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new food item
  Future<http.Response> createFood(Map<String, dynamic> foodData) async {
    final url = Uri.parse('$baseUrl/foods');
    _logRequest('POST', url, body: foodData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(foodData),
    );
    _logResponse(response);
    return response;
  }

  // Get order reports
  Future<http.Response> getOrderReports() async {
    final url = Uri.parse('$baseUrl/reports/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get payment reports
  Future<http.Response> getPaymentReports() async {
    final url = Uri.parse('$baseUrl/reports/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get user's favorites
  Future<http.Response> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Add to favorites
  Future<http.Response> addToFavorites(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId}),
    );
    _logResponse(response);
    return response;
  }

  // Remove from favorites
  Future<http.Response> removeFromFavorites(int favoriteId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites/$favoriteId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  addFavorite() {}

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/logout');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  getCheckoutData(Map<String, dynamic> checkoutData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/payments/initialize-transaction');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      body: jsonEncode(checkoutData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // createOrder(Map<String, dynamic> checkoutData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token') ?? '';

  //   final url = Uri.parse('$baseUrl/payments/initialize-transaction');
  //   _logRequest('POST', url);
  //   final response = await http.post(
  //     url,
  //     body: jsonEncode(checkoutData),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   _logResponse(response);
  //   return response;
  // }

  // PIN endpoints
  Future<http.Response> setPIN(Map<String, dynamic> pinData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/pin/set');
    _logRequest('POST', url, body: pinData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(pinData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> verifyPIN(Map<String, dynamic> pinData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/pin/verify');
    _logRequest('POST', url, body: pinData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(pinData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> validatePIN() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final pinToken = prefs.getString('pin_token') ?? '';

    final url = Uri.parse('$baseUrl/pin/validate');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'X-PIN-TOKEN': pinToken,
        'Accept': 'application/json',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> clearPIN() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/pin/clear');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    _logResponse(response);
    return response;
  }

  // // Fetch banks for withdrawal
  // Future<http.Response> fetchBanks() async {
  //   var token = await dataBase.getToken();
  //   if (token.isEmpty) {
  //     if (kDebugMode) {
  //       print('Token is empty when fetching banks');
  //     }
  //     throw Exception('Authentication token is missing');
  //   }
  //   final url = Uri.parse('$baseUrl/banks');
  //   _logRequest('GET', url);
  //   final response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   _logResponse(response);
  //   return response;
  // }

  Future<Map<String, String>> _authHeaders({String? pinToken}) async {
    final db = Get.find<DataBase>();
    final token = await db.getToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (pinToken != null) headers['X-PIN-TOKEN'] = pinToken;
    return headers;
  }

  Future<Map<String, String>> _authHeadersMultipart() async {
    final db = Get.find<DataBase>();
    final token = await db.getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  // ─── Auth / PIN ───────────────────────────────────────────────────────────

  Future<http.Response> setPin(String pin, String confirmPin) async {
    return http
        .post(
          _uri('/pin/set'),
          headers: await _authHeaders(),
          body: jsonEncode({'pin': pin, 'confirm_pin': confirmPin}),
        )
        .timeout(timeout);
  }

  Future<http.Response> verifyPin(String pin, {bool remember = false}) async {
    return http
        .post(
          _uri('/pin/verify'),
          headers: await _authHeaders(),
          body: jsonEncode({'pin': pin, 'remember': remember}),
        )
        .timeout(timeout);
  }

  Future<http.Response> validatePin(String pinToken) async {
    return http
        .get(_uri('/pin/validate'),
            headers: await _authHeaders(pinToken: pinToken))
        .timeout(timeout);
  }

  Future<http.Response> requestPinReset() async {
    return http
        .post(_uri('/pin/request-reset'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> resetPin(
      String token, String pin, String confirmPin) async {
    return http
        .post(
          _uri('/pin/reset'),
          headers: await _authHeaders(),
          body: jsonEncode({
            'token': token,
            'pin': int.tryParse(pin) ?? pin,
            'confirm_pin': int.tryParse(confirmPin) ?? confirmPin,
          }),
        )
        .timeout(timeout);
  }

  // ─── Customer ─────────────────────────────────────────────────────────────

  Future<http.Response> fetchUser() async {
    return http
        .get(_uri('/fetch-user'), headers: await _authHeaders())
        .timeout(timeout);
  }

  // Future<http.Response> fetchWallet() async {
  //   return http
  //       .get(_uri('/fetch-wallet'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  Future<http.Response> logout() async {
    return http
        .post(_uri('/logout'), headers: await _authHeaders())
        .timeout(timeout);
  }

  // ─── Payments / Wallet ────────────────────────────────────────────────────

  Future<http.Response> initializeTransaction({
    required double amount,
    String currency = 'NGN',
    String? callbackUrl,
    Map<String, dynamic>? metadata,
    String paymentGateway = 'paystack',
  }) async {
    return http
        .post(
          _uri('/payments/initialize-transaction'),
          headers: await _authHeaders(),
          body: jsonEncode({
            'amount': amount,
            'currency': currency,
            'callback_url': callbackUrl ?? 'https://ryda.com.ng',
            'metadata': metadata ?? {},
            'payment_gateway': paymentGateway,
          }),
        )
        .timeout(timeout);
  }

  // Future<http.Response> fundWallet(Map<String, dynamic> data) async {
  //   return http
  //       .post(
  //         _uri('/payments/initialize-transaction'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  Future<http.Response> verifyTransaction(String reference) async {
    return http
        .get(_uri('/verify-transaction/$reference'),
            headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> fetchPayments() async {
    return http
        .get(_uri('/payments'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> transferToBank(Map<String, dynamic> data,
      {String? pinToken}) async {
    return http
        .post(
          _uri('/wallet/transfer-to-bank'),
          headers: await _authHeaders(pinToken: pinToken),
          body: jsonEncode(data),
        )
        .timeout(timeout);
  }

  Future<http.Response> fetchTransfers() async {
    return http
        .get(_uri('/transfers'), headers: await _authHeaders())
        .timeout(timeout);
  }

  // ─── Banks ────────────────────────────────────────────────────────────────

  Future<http.Response> fetchBanks({String? search}) async {
    return http
        .get(
          _uri('/banks', search != null ? {'search': search} : null),
          headers: await _authHeaders(),
        )
        .timeout(timeout);
  }

  // ─── Notifications ────────────────────────────────────────────────────────

  Future<http.Response> fetchNotifications() async {
    return http
        .get(_uri('/notifications'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> fetchUnreadCount() async {
    return http
        .get(_uri('/notifications/unread-count'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> markNotificationRead(int id) async {
    return http
        .post(_uri('/notifications/$id/read'), headers: await _authHeaders())
        .timeout(timeout);
  }

  // ─── Delivery Addresses ───────────────────────────────────────────────────

  Future<http.Response> getAddresses() async {
    return http
        .get(_uri('/addresses'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> storeAddress(Map<String, dynamic> data) async {
    return http
        .post(
          _uri('/addresses'),
          headers: await _authHeaders(),
          body: jsonEncode(data),
        )
        .timeout(timeout);
  }

  Future<http.Response> updateAddress(int id, Map<String, dynamic> data) async {
    return http
        .put(
          _uri('/addresses/$id'),
          headers: await _authHeaders(),
          body: jsonEncode(data),
        )
        .timeout(timeout);
  }

  // ─── States / LGA ─────────────────────────────────────────────────────────

  Future<http.Response> fetchStates({String? name}) async {
    return http
        .get(
          _uri('/states', name != null ? {'name': name} : null),
          headers: await _authHeaders(),
        )
        .timeout(timeout);
  }

  // Future<http.Response> fetchLgas({String? stateId, String? search}) async {
  //   final query = <String, String>{};
  //   if (stateId != null) query['state'] = stateId;
  //   if (search != null) query['search'] = search;
  //   return http
  //       .get(_uri('/lgas', query.isNotEmpty ? query : null), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // ─── Orders ───────────────────────────────────────────────────────────────

  Future<http.Response> createOrder(Map<String, dynamic> data,
      {File? audio}) async {
    if (audio != null) {
      final request = http.MultipartRequest('POST', _uri('/orders'))
        ..headers.addAll(await _authHeadersMultipart());
      data.forEach((key, value) {
        if (value != null) request.fields[key] = value.toString();
      });
      request.files.add(await http.MultipartFile.fromPath('audio', audio.path));
      final streamed = await request.send().timeout(timeout);
      return http.Response.fromStream(streamed);
    }
    return http
        .post(
          _uri('/orders'),
          headers: await _authHeaders(),
          body: jsonEncode(data),
        )
        .timeout(timeout);
  }

  // Future<http.Response> getOrder(int id) async {
  //   return http
  //       .get(_uri('/orders/$id'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  Future<http.Response> getAllOrders() async {
    return http
        .get(_uri('/orders'), headers: await _authHeaders())
        .timeout(timeout);
  }

  // Future<http.Response> cancelOrder(int orderId) async {
  //   return http
  //       .post(_uri('/orders/$orderId/cancel'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // ─── Checkout address helper (used by CartController) ────────────────────

//  Future<http.Response> getCheckoutAddress() async => getAddresses();
}

ApiService apiService = ApiService(API_TIMEOUT_DURATION);

/// Converts a relative image path returned by the API (e.g. "food/xyz.jpg")
/// into a full URL using the same host/port as the API base URL.
String getImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  final uri = Uri.parse(apiService.baseUrl ?? '');
  final root =
      '${uri.scheme}://${uri.host}${(uri.port != 80 && uri.port != 443) ? ':${uri.port}' : ''}';
  return '$root/storage/$path';
}


// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:jara_market/config/local_storage.dart';
// import 'package:get/get.dart';

//class ApiService {
  // final Duration timeout;
  // static const String _baseUrl = 'https://ryda.com.ng/api/jaram';
  // String get baseUrl => _baseUrl;

  // ApiService(this.timeout);

  // ─── Helpers ─────────────────────────────────────────────────────────────

  // Future<Map<String, String>> _authHeaders({String? pinToken}) async {
  //   final db = Get.find<DataBase>();
  //   final token = await db.getToken();
  //   final headers = <String, String>{
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //   if (pinToken != null) headers['X-PIN-TOKEN'] = pinToken;
  //   return headers;
  // }

  // Future<Map<String, String>> _authHeadersMultipart() async {
  //   final db = Get.find<DataBase>();
  //   final token = await db.getToken();
  //   return {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  // }

  // Uri _uri(String path, [Map<String, String>? query]) =>
  //     Uri.parse('$_baseUrl$path').replace(queryParameters: query);

  // // ─── Auth / PIN ───────────────────────────────────────────────────────────

  // Future<http.Response> setPin(String pin, String confirmPin) async {
  //   return http
  //       .post(
  //         _uri('/pin/set'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode({'pin': pin, 'confirm_pin': confirmPin}),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> verifyPin(String pin, {bool remember = false}) async {
  //   return http
  //       .post(
  //         _uri('/pin/verify'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode({'pin': pin, 'remember': remember}),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> validatePin(String pinToken) async {
  //   return http
  //       .get(_uri('/pin/validate'), headers: await _authHeaders(pinToken: pinToken))
  //       .timeout(timeout);
  // }

  // Future<http.Response> requestPinReset() async {
  //   return http
  //       .post(_uri('/pin/request-reset'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> resetPin(
  //     String token, String pin, String confirmPin) async {
  //   return http
  //       .post(
  //         _uri('/pin/reset'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode({
  //           'token': token,
  //           'pin': int.tryParse(pin) ?? pin,
  //           'confirm_pin': int.tryParse(confirmPin) ?? confirmPin,
  //         }),
  //       )
  //       .timeout(timeout);
  // }

  // // ─── Customer ─────────────────────────────────────────────────────────────

  // Future<http.Response> fetchUser() async {
  //   return http
  //       .get(_uri('/fetch-user'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> fetchWallet() async {
  //   return http
  //       .get(_uri('/fetch-wallet'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> logout() async {
  //   return http
  //       .post(_uri('/logout'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // // ─── Payments / Wallet ────────────────────────────────────────────────────

  // Future<http.Response> initializeTransaction({
  //   required double amount,
  //   String currency = 'NGN',
  //   String? callbackUrl,
  //   Map<String, dynamic>? metadata,
  //   String paymentGateway = 'paystack',
  // }) async {
  //   return http
  //       .post(
  //         _uri('/payments/initialize-transaction'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode({
  //           'amount': amount,
  //           'currency': currency,
  //           'callback_url': callbackUrl ?? 'https://ryda.com.ng',
  //           'metadata': metadata ?? {},
  //           'payment_gateway': paymentGateway,
  //         }),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> fundWallet(Map<String, dynamic> data) async {
  //   return http
  //       .post(
  //         _uri('/payments/initialize-transaction'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> verifyTransaction(String reference) async {
  //   return http
  //       .get(_uri('/verify-transaction/$reference'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> fetchPayments() async {
  //   return http
  //       .get(_uri('/payments'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> transferToBank(Map<String, dynamic> data) async {
  //   return http
  //       .post(
  //         _uri('/wallet/transfer-to-bank'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> fetchTransfers() async {
  //   return http
  //       .get(_uri('/transfers'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // // ─── Banks ────────────────────────────────────────────────────────────────

  // Future<http.Response> fetchBanks({String? search}) async {
  //   return http
  //       .get(
  //         _uri('/banks', search != null ? {'search': search} : null),
  //         headers: await _authHeaders(),
  //       )
  //       .timeout(timeout);
  // }

  // // ─── Notifications ────────────────────────────────────────────────────────

  // Future<http.Response> fetchNotifications() async {
  //   return http
  //       .get(_uri('/notifications'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> fetchUnreadCount() async {
  //   return http
  //       .get(_uri('/notifications/unread-count'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> markNotificationRead(int id) async {
  //   return http
  //       .post(_uri('/notifications/$id/read'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // // ─── Delivery Addresses ───────────────────────────────────────────────────

  // Future<http.Response> getAddresses() async {
  //   return http
  //       .get(_uri('/addresses'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> storeAddress(Map<String, dynamic> data) async {
  //   return http
  //       .post(
  //         _uri('/addresses'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> updateAddress(int id, Map<String, dynamic> data) async {
  //   return http
  //       .put(
  //         _uri('/addresses/$id'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  // // ─── States / LGA ─────────────────────────────────────────────────────────

  // Future<http.Response> fetchStates({String? name}) async {
  //   return http
  //       .get(
  //         _uri('/states', name != null ? {'name': name} : null),
  //         headers: await _authHeaders(),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> fetchLgas({String? stateId, String? search}) async {
  //   final query = <String, String>{};
  //   if (stateId != null) query['state'] = stateId;
  //   if (search != null) query['search'] = search;
  //   return http
  //       .get(_uri('/lgas', query.isNotEmpty ? query : null), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // // ─── Orders ───────────────────────────────────────────────────────────────

  // Future<http.Response> createOrder(Map<String, dynamic> data, {File? audio}) async {
  //   if (audio != null) {
  //     final request = http.MultipartRequest('POST', _uri('/orders'))
  //       ..headers.addAll(await _authHeadersMultipart());
  //     data.forEach((key, value) {
  //       if (value != null) request.fields[key] = value.toString();
  //     });
  //     request.files.add(await http.MultipartFile.fromPath('audio', audio.path));
  //     final streamed = await request.send().timeout(timeout);
  //     return http.Response.fromStream(streamed);
  //   }
  //   return http
  //       .post(
  //         _uri('/orders'),
  //         headers: await _authHeaders(),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(timeout);
  // }

  // Future<http.Response> getOrder(int id) async {
  //   return http
  //       .get(_uri('/orders/$id'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> getAllOrders() async {
  //   return http
  //       .get(_uri('/orders'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // Future<http.Response> cancelOrder(int orderId) async {
  //   return http
  //       .post(_uri('/orders/$orderId/cancel'), headers: await _authHeaders())
  //       .timeout(timeout);
  // }

  // // ─── Checkout address helper (used by CartController) ────────────────────

  // Future<http.Response> getCheckoutAddress() async => getAddresses();

