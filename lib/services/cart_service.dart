import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jara_market/services/api_service.dart';

class CartService {
  ApiService basepath = ApiService(Duration(seconds: 60 * 5));
  static const String cartsEndpoint = '/carts';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> getActiveCart() async {
  final token = await _getToken();
  if (token == null) throw Exception('No authentication token found');

  final response = await http.get(
    Uri.parse('${basepath.baseUrl}$cartsEndpoint'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('--------------------------------');
  print('${basepath.baseUrl}$cartsEndpoint');
  print(response.statusCode);
  print(response.body);
  print(response.headers);
  print(response.request);
  print('--------------------------------');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final carts = data['data'] as List;

    if (carts.isNotEmpty) {
      return carts.first as Map<String, dynamic>;
    } else {
      //throw Exception('No active cart found'); // or return {} or null if preferred
      return {}; // Return an empty map if no active cart is found
    }
  } else {
    throw Exception('Failed to load cart');
  }
}


  Future<Map<String, dynamic>> addItemToCart({
    required int productId,
    required int quantity,
  }) async {
    if (quantity < 1) {
      throw Exception('Quantity must be at least 1');
    }

    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.post(
      Uri.parse('${basepath.baseUrl}$cartsEndpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );
    print('--------------------------------');
    print('${basepath.baseUrl}$cartsEndpoint');
    print(response.statusCode);
    print(response.body);
    print(response.headers);
    print(response.request);
    print('--------------------------------');

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to add item to cart');
    }
  }

  Future<Map<String, dynamic>> updateCartItem(
      int cartId, int itemId, int quantity) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.put(
      Uri.parse('${basepath.baseUrl}$cartsEndpoint/$cartId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'item_id': itemId,
        'quantity': quantity,
      }),
    );
    print('--------------------------------');
    print('${basepath.baseUrl}$cartsEndpoint');
    print(response.statusCode);
    print(response.body);
    print(response.headers);
    print(response.request);
    print('--------------------------------');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to update cart item');
    }
  }

  Future<void> removeCartItem(int cartId, int itemId) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.delete(
      Uri.parse('${basepath.baseUrl}$cartsEndpoint/$cartId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'item_id': itemId,
      }),
    );
    print('--------------------------------');
    print('${basepath.baseUrl}$cartsEndpoint');
    print(response.statusCode);
    print(response.body);
    print(response.headers);
    print(response.request);
    print('--------------------------------');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to remove cart item');
    }
  }
}
