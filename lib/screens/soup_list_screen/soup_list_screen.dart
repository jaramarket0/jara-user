// lib/screens/soup_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
import 'package:jara_market/screens/home_screen/models/models.dart';
import 'package:jara_market/screens/soup_list_screen/controller/soup_list_controller.dart';
import 'package:jara_market/services/favorites_service.dart';
import 'package:jara_market/widgets/app_header.dart';
import 'package:jara_market/widgets/food_card.dart';

SoupListController controller = Get.put(SoupListController());

class SoupListScreen extends StatefulWidget {
  final Category item;
  const SoupListScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<SoupListScreen> createState() => _SoupListScreenState();
}

class _SoupListScreenState extends State<SoupListScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesService.getUserFavorites();
      setState(() {
        _favorites = favorites;
      });
    } catch (e) {
      // Handle error appropriately
      debugPrint('Error loading favorites: $e');
    }
  }

  bool _isFavorite(int productId) {
    return _favorites.any((favorite) => favorite['product_id'] == productId);
  }

  Future<void> _toggleFavorite(int productId, bool isCurrentlyFavorite) async {
    try {
      if (isCurrentlyFavorite) {
        final favorite = _favorites.firstWhere(
          (f) => f['product_id'] == productId,
        );
        await _favoritesService.removeFromFavorites(favorite['id']);
      } else {
        await _favoritesService.addToFavorites(productId);
      }
      await _loadFavorites(); // Refresh the favorites list
    } catch (e) {
      // Handle error appropriately
      debugPrint('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Products> foods = widget.item.products ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: widget.item.name?.toString() ?? 'Food List',
              onBackPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8,bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(style: BorderStyle.solid,
                        color: const Color(0xffE0E0E0),
                        width: 1,
                    ),
                  //  (
                     // color: Color(0xffE0E0E0),
                    //  width: 1,
                //    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0x1919190D),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffE0E0E0),
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xffF4F4F6),
                ),
              ),
            ),
            Expanded(
              child: foods.isEmpty
                  ? const Center(
                      child: Text('No foods available in this category'),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(8),
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1.2,
                      children: foods
                          .map((food) => FoodCard(
                                imageUrl: food.imageUrl?.toString() ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG3jTszSflQt-SjZGIWqJRegF0GrAVzpCQtg&s',
                                name:
                                    food.name?.toString() ?? 'Unnamed Food',
                                rating: (food.rating is num)
                                    ? (food.rating as num).toDouble()
                                    : 0.0,
                                reviews:
                                    0, // Since reviews count is not in the API response
                                isFavorite: _isFavorite(food.id!
                                ),
                                onFavoritePressed: () => _toggleFavorite(
                                  food.id!,
                                  _isFavorite(food.id!
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FoodDetailScreen(item: food)),
                                  );
                                },
                                showMostOrdered: true,
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
