import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/browse_screen/controller/browse_controller.dart';
import '../../widgets/app_header.dart';
import '../../widgets/filter_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/custom_bottom_nav.dart';

BrowseController controller = Get.put(BrowseController());

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  int _currentIndex = 1; // Browse tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Meat',
              onBackPressed: () => Navigator.pop(context),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.tune),
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Category',
                    onPressed: () {
                      // Show category filter
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Brand',
                    onPressed: () {
                      // Show brand filter
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Price',
                    onPressed: () {
                      // Show price filter
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '13\'134 products',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  const Text('Sort by'),
                  TextButton(
                    onPressed: () {
                      // Show sort options
                    },
                    child: const Row(
                      children: [
                        Text('Relevance'),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4, // Sample items
                itemBuilder: (context, index) {
                  final items = [
                    {
                      'title': 'Grilled Turkey',
                      'price': 25000,
                      'originalPrice': 50000,
                      'discount': '50',
                      'rating': 4.3,
                      'reviews': 41,
                      'trending': true,
                      'image': 'assets/images/grilled-turkey.png',
                    },
                    {
                      'title': 'Live Chicken',
                      'price': 15000,
                      'originalPrice': 15000,
                      'discount': '20',
                      'rating': 4.1,
                      'reviews': 87,
                      'image': 'assets/images/live-chicken.png',
                    },
                    {
                      'title': 'Live Turkey',
                      'price': 50000,
                      'originalPrice': 50000,
                      'discount': '50',
                      'rating': 4.3,
                      'reviews': 41,
                      'image': 'assets/images/live-turkey.png',
                    },
                    {
                      'title': 'Grilled Chicken',
                      'price': 15000,
                      'originalPrice': 15000,
                      'discount': '25',
                      'rating': 4.8,
                      'reviews': 692,
                      'trending': true,
                      'image': 'assets/images/grilled-chicken.png',
                    },
                  ];
                  final item = items[index];
                  return ProductCard(
                    imageAsset: item['image'] as String,
                    title: item['title'] as String,
                    price: item['price'] as double,
                    originalPrice: item['originalPrice'] as double,
                    rating: item['rating'] as double,
                    reviews: item['reviews'] as int,
                    isTrending: item['trending'] as bool? ?? false,
                    discountPercentage: item['discount'] as String,
                    isFavorite: false,
                    onTap: () {
                      // Navigate to product detail
                    },
                    onFavoritePress: () {},
                    isTopSeller: false, isMostOrdered: false, onFavoritePressed: () {  },
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

