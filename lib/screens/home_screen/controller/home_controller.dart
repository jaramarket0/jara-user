import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/cupertino.dart';
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

  // List<dynamic> _foodCategories = [];
  // List<dynamic> get foodCategories => _foodCategories;
  // List<dynamic> _filteredFoodCategories = [];
  //List<dynamic> get filteredFoodCategories => _filteredFoodCategories;
  RxBool _isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool get isLoading => _isLoading;

  RxBool isSearching = false.obs;
  RxList<Products> searchResults = <Products>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoodCategoriesByCondition();
    //  fetchFoods();
  }

  fetchFoodCategoriesByCondition() async {
    //AddressGoogleChangeScreen
    var stateId = await dataBase.getStateAddressId();
    var lgaId = await dataBase.getLGAAddressId();
    myLog.log('state id from storage: $stateId', name: 'STATE ID');
    myLog.log('LGA id from storage: $lgaId', name: 'LGA ID');
    myLog.log('Found a state id: $stateId', name: 'HomeController');
    if (stateId.isNotEmpty) {
      if (category.isNotEmpty || _isLoading.value) {
        return;
      }
      fetchFoodCategories(lgaId.toString(), stateId);
      return;
    }
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => AddressGoogleChangeScreen(),
        ));
  }

  // void filterFoodCategories(String query) {
  //   if (query.isEmpty) {
  //     _filteredFoodCategories = _foodCategories; // Reset to original list
  //   } else {
  //     _filteredFoodCategories = _foodCategories.where((category) {
  //       return category['name'].toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   update(); // Notify listeners to update the UI
  // }

  Future<void> fetchFoodCategories(String? lgaId, String? stateId) async {
    if (Get.isSnackbarOpen) return;
    isLoading.value = true;
    try {
      final response =
          await apiService.fetchFoodCategory(lgaId ?? '4', stateId ?? '');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // var body = jsonDecode(response.body);
          //  myLog.log("Response body: $body", name: 'HomeController');
          final decodedData = jsonDecode(response.body);
          myLog.log("Response body: ${decodedData}", name: 'HomeController');

          categories = categoriesFromJson(response.body);
          category = categories.data!;
          myLog.log(category.length.toString());
          //  myLog.log('Decoded Data: $decodedData', name: 'HomeController');

          // setState(() {
          //   _foodCategories = decodedData;
          //   _filteredFoodCategories = decodedData; // Initialize filtered list
          isLoading.value = false;
          // });
        } catch (e, stackTrace) {
          print('Error decoding food categories: $e');
          print('Stack Trace: $stackTrace');

          isLoading.value = false;

          showErrorSnackBar('Failed to parse food categories dataxxx');
        }
      } else {
        isLoading.value = false;

        showErrorSnackBar('Failed to load categories: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching food categories: $e');
      print('Stack Trace: $stackTrace');

      isLoading.value = false;

      showErrorSnackBar('Error loading categories: $e');
    }
  }

  Future<void> searchProducts(String query,String lgaId, String stateId) async {
    isSearching.value = true;
    _isLoading.value = true;
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
  //   try {
  //     final response = await apiService.fetchIngredients();
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       try {
  //         final decodedData = jsonDecode(response.body);
  //         // setState(() {
  //         //   ingredients = decodedData;
  //         //   filteredIngredients = decodedData; // Initialize filtered list
  //           isLoading1.value = false;
  //         // });
  //       } catch (e, stackTrace) {
  //         print('Error decoding ingredients: $e');
  //         print('Stack Trace: $stackTrace');

  //           isLoading1.value = false;

  //         showErrorSnackBar('Failed to parse ingredients data');
  //       }
  //     } else {

  //         isLoading1.value = false;

  //       showErrorSnackBar('Failed to load ingredients: ${response.body}');
  //     }
  //   } catch (e, stackTrace) {
  //     print('Error fetching ingredients: $e');
  //     print('Stack Trace: $stackTrace');

  //       isLoading1.value = false;

  //     showErrorSnackBar('Error loading ingredients: $e');
  //   }
  // }

  Future<void> fetchFoods() async {
    try {
      final response = await apiService.fetchFood();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          myLog.log('Decoded Data: $decodedData', name: 'HomeController');
          foods = foodFromJson(response.body);
          myLog.log('Foods: $foods', name: 'HomeController');
          // _foods = decodedData;
          // _filteredFoods = decodedData; // Initialize filtered list
          isLoading1.value = false;
        } catch (e, stackTrace) {
          print('Error decoding foods: $e');
          print('Stack Trace: $stackTrace');

          isLoading1.value = false;

          showErrorSnackBar('Failed to parse foods data');
        }
      } else {
        isLoading1.value = false;

        showErrorSnackBar('Failed to load foods: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching foods: $e');
      print('Stack Trace: $stackTrace');

      isLoading1.value = false;

      showErrorSnackBar('Error loading foods: $e');
    }
  }

  Future<bool> addFavorite(int id) async {
    //if (Get.isSnackbarOpen) return;

    try {
      final response = await apiService.addToFavorites(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
              content: Text('Added to favorites'),
              backgroundColor: Colors.green),
        );
      } else {
        showErrorSnackBar('Failed to add to favorites: ${response.body}');
      }
      return true;
    } catch (e, stackTrace) {
      print('Error adding to favorites: $e');
      print('Stack Trace: $stackTrace');
      showErrorSnackBar('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFavorite(int id) async {
    //if (Get.isSnackbarOpen) return;

    try {
      final response = await apiService.removeFromFavorites(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
              content: Text('Removed from favorites'),
              backgroundColor: Colors.red),
        );
      } else {
        showErrorSnackBar('Failed to remove from favorites: ${response.body}');
      }
      return true;
    } catch (e, stackTrace) {
      print('Error removing from favorites: $e');
      print('Stack Trace: $stackTrace');
      showErrorSnackBar('Error removing from favorites: $e');
      return false;
    }
  }
}
