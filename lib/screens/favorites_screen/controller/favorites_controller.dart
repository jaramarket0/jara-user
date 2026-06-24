import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/models/food_item.dart';
import 'package:jara_market/screens/favorites_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/services/cart_service.dart';
import 'package:jara_market/widgets/snacknar.dart';

class FavoritesController extends GetxController {
  RxBool isLoading = false.obs;
  final CartService _cartService = CartService();
  RxList<FoodItem> favouriteItems = <FoodItem>[].obs;
  List<Favourite> favourite = <Favourite>[];
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

@override
  void onInit() {
    super.onInit();
    fetchFavorites();
  //  fetchFoods();
  }

Future<void> fetchFavorites() async {
  isLoading.value = true;
    try {
      final response = await _apiService.getFavorites();
      if (response.statusCode == 200 || response.statusCode == 201) {

      // final List<dynamic> data = json.decode(response.body);
        favourite = favouriteFromJson(response.body);
        myLog.log('Fetched Favorites: ${favourite.length}', name: 'FavoritesController');
      //     favouriteItems.value = data
      //         .map((item) => FoodItem(
      //               id: item['id'].toString(),
      //               name: item['name'] ?? 'Unknown',
      //               description: item['description'] ?? '',
      //               price: (item['price'] ?? 0).toDouble(),
      //               imageUrl: item['image_url'] ?? '',
      //             ))
      //         .toList();
      //     isLoading.value = false;
      //     myLog.log('Fetched Favorites: ${favourite.length}', name: 'FavoritesController');

      print('====================');
      } else {
        isLoading.value = false;
      }
    } catch (e) {
   
        isLoading.value = false;
        print('Error fetching favorites: $e');
   
    }finally{
       isLoading.value = false;
    }
  }

  Future<void> addToCart(FoodItem item) async {
    try {
      await _cartService.addItemToCart(
        productId: int.parse(item.id),
        quantity: 1,
      );

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
     
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content:
              Text('Failed to add ${item.name} to cart: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      }

  Future<bool> removeFavorite(int id) async {
    //if (Get.isSnackbarOpen) return;

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
      print('Error removing from favorites: $e');
      print('Stack Trace: $stackTrace');
      showErrorSnackBar('Error removing from favorites: $e');
      return false;
    }
  }

  void showMoreOptionsBottomSheet(BuildContext context, FoodItem item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.shopping_cart, color: Color(0xFFFFAA00)),
                title: const Text('Add to Cart'),
                onTap: () {
                  Navigator.pop(context);
                  addToCart(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove from Favorites'),
                onTap: () async {
                  try {
                    await removeFavorite(int.parse(item.id));
                    Navigator.pop(context);
                    fetchFavorites(); // Refresh the list
                    // if (mounted) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Removed from favorites'),
                    //       duration: Duration(seconds: 1),
                    //     ),
                    //   );
                    // }
                  } catch (e) {
                    Navigator.pop(context);
                    // if (mounted) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Failed to remove: $e'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  }

  Future<bool> removeFavorite(int id) async {
    //if (Get.isSnackbarOpen) return;

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
      print('Error removing from favorites: $e');
      print('Stack Trace: $stackTrace');
      showErrorSnackBar('Error removing from favorites: $e');
      return false;
    }
  }}