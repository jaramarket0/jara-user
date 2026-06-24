import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jara_market/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
class FavoritesService {
  static const String favoritesEndpoint = '/favorites';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> getUserFavorites() async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('${_apiService.baseUrl}$favoritesEndpoint'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addToFavorites(int productId) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.post(
      Uri.parse('${_apiService.baseUrl}$favoritesEndpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add to favorites');
    }
  }

  Future<void> removeFromFavorites(int favoriteId) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.delete(
      Uri.parse('${_apiService.baseUrl}$favoritesEndpoint/$favoriteId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }
}
