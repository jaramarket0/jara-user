import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/address_google.dart';
import 'package:jara_market/screens/home_screen/models/food_model.dart';
import 'package:jara_market/screens/home_screen/models/models.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/widgets/snacknar.dart';

class HomeController extends GetxController {
  ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  Categories categories = Categories(data: [], message: 'success');
  List<Category> category = <Category>[];
  RxList<Products> product = <Products>[].obs;

  List<Food> foods = <Food>[];
  RxList<Ingredient> ingredient = <Ingredient>[].obs;

  RxBool _isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool get isLoading => _isLoading;

  // Pagination state
  int _currentPage = 1;
  int _lastPage    = 1;
  bool _hasMore    = true;
  RxBool isLoadingMore = false.obs;
  String? _cachedLgaId;
  String? _cachedStateId;

  bool get hasMore => _hasMore;

  RxBool isSearching = false.obs;
  RxList<Products> searchResults = <Products>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoodCategoriesByCondition();
  }

  fetchFoodCategoriesByCondition() async {
    var stateId = await dataBase.getStateAddressId();
    var lgaId   = await dataBase.getLGAAddressId();
    myLog.log('state id: $stateId  lga id: $lgaId', name: 'HomeController');
    if (stateId.isNotEmpty) {
      if (category.isNotEmpty || _isLoading.value) return;
      fetchFoodCategories(lgaId.toString(), stateId);
      return;
    }
    Navigator.push(
        Get.context!,
        MaterialPageRoute(builder: (context) => AddressGoogleChangeScreen()));
  }

  Future<void> fetchFoodCategories(String? lgaId, String? stateId,
      {bool reset = true}) async {
    if (Get.isSnackbarOpen) return;

    if (reset) {
      _currentPage    = 1;
      _hasMore        = true;
      _cachedLgaId    = lgaId;
      _cachedStateId  = stateId;
      _isLoading.value = true;
    } else {
      if (!_hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final response = await apiService.fetchFoodCategory(
        lgaId ?? _cachedLgaId ?? '4',
        stateId ?? _cachedStateId ?? '',
        page: _currentPage,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsed = categoriesFromJson(response.body);
        _lastPage = parsed.lastPage ?? 1;
        _hasMore  = _currentPage < _lastPage;

        if (reset) {
          category = parsed.data ?? [];
        } else {
          category.addAll(parsed.data ?? []);
        }
        _currentPage++;
        myLog.log(
            'Page ${_currentPage - 1} loaded — total cats: ${category.length}',
            name: 'HomeController');
      } else {
        showErrorSnackBar('Failed to load categories: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching food categories: $e\n$stackTrace');
      showErrorSnackBar('Error loading categories: $e');
    } finally {
      _isLoading.value    = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreCategories() async {
    if (!_hasMore || isLoadingMore.value) return;
    await fetchFoodCategories(null, null, reset: false);
  }

  Future<void> searchProducts(String query, String lgaId, String stateId) async {
    isSearching.value = true;
    _isLoading.value  = true;
    try {
      final response = await apiService
          .get('/fetch/product?search=$query&lga_id=$lgaId&&state_id=$stateId');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          searchResults.value = (decoded['data'] as List)
              .map((e) => Products.fromJson(e))
              .toList();
        } else {
          searchResults.clear();
        }
      } else {
        showErrorSnackBar('Search failed: ${response.body}');
        searchResults.clear();
      }
    } catch (e) {
      showErrorSnackBar('Error searching: $e');
      searchResults.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearSearch() {
    isSearching.value = false;
    searchResults.clear();
  }

  Future<void> fetchFoods() async {
    try {
      final response = await apiService.fetchFood();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        myLog.log('Decoded Data: $decodedData', name: 'HomeController');
        foods = foodFromJson(response.body);
        isLoading1.value = false;
      } else {
        isLoading1.value = false;
        showErrorSnackBar('Failed to load foods: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching foods: $e\n$stackTrace');
      isLoading1.value = false;
      showErrorSnackBar('Error loading foods: $e');
    }
  }

  Future<bool> addFavorite(int id) async {
    try {
      final response = await apiService.addToFavorites(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Added to favorites'), backgroundColor: Colors.green),
        );
      } else {
        showErrorSnackBar('Failed to add to favorites: ${response.body}');
      }
      return true;
    } catch (e, stackTrace) {
      print('Error adding to favorites: $e\n$stackTrace');
      showErrorSnackBar('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFavorite(int id) async {
    try {
      final response = await apiService.removeFromFavorites(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Removed from favorites'), backgroundColor: Colors.red),
        );
      } else {
        showErrorSnackBar('Failed to remove from favorites: ${response.body}');
      }
      return true;
    } catch (e, stackTrace) {
      print('Error removing from favorites: $e\n$stackTrace');
      showErrorSnackBar('Error removing from favorites: $e');
      return false;
    }
  }
}
