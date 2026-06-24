import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/category_screen/controller/category_controller.dart';
import 'package:jara_market/widgets/custom_bottom_nav.dart';
import '../../widgets/product_card.dart';

CategoryController controller = Get.put(CategoryController());

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Meat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(Icons.filter_list, 'Filter'),
                  _buildFilterChip(null, 'Category'),
                  _buildFilterChip(null, 'Brand'),
                  _buildFilterChip(null, 'Price'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '13,134 products',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text('Sort by Relevance'),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).primaryColor,
                      ),
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
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ProductCard(
                  imageAsset: 'assets/images/meat_${index + 1}.jpg',
                  title: index % 2 == 0 ? 'Grilled Turkey' : 'Live Chicken',
                  price: index % 2 == 0 ? 25000.0 : 15000.0,
                  originalPrice: index % 2 == 0 ? 50000.0 : 15000.0,
                  rating: index % 2 == 0 ? 4.3 : 4.1,
                  reviews: index % 2 == 0 ? 41 : 87,
                  isTrending: index % 2 == 0,
                  discountPercentage: '${index % 2 == 0 ? 50 : 20}% OFF',
                  onFavoritePress: () {},
                  onCartPress: () {},
                  isTopSeller: false,
                  isFavorite: false,
                  onTap: () {},
                  isMostOrdered: false,
                  onFavoritePressed: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(IconData? icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 4),
            ],
            Text(label),
            if (label != 'Filter') ...[
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ],
        ),
        onSelected: (bool selected) {},
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
