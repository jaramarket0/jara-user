import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/categories_screen/controller/categories_controller.dart';
// import 'package:jara_market/widgets/custom_bottom_nav.dart';
import '../../widgets/category_icon.dart';
import '../soup_list_screen/soup_list_screen.dart';
import '../grains_screen/grains_screen.dart'; // Import GrainsScreen

CategoriesController controller = Get.put(CategoriesController());

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  CategoryIcon(
                    icon: Icons.grass,
                    label: 'Grains',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GrainsScreen(forProduct: false,)),
                      );
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.food_bank,
                    label: 'Swallow',
                    backgroundColor: Colors.orange.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.spa,
                    label: 'Tubers',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.egg,
                    label: 'Protein',
                    backgroundColor: Colors.blue.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.eco,
                    label: 'Vegetables',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.soup_kitchen,
                    label: 'Spices/Paste',
                    backgroundColor: Colors.orange.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.water_drop,
                    label: 'Cooking Oil',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.grain,
                    label: 'Rice',
                    backgroundColor: Colors.blue.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.set_meal,
                    label: 'Sea Food',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.food_bank,
                    label: 'Swallow',
                    backgroundColor: Colors.orange.shade50,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Food & Recipes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  CategoryIcon(
                    icon: Icons.soup_kitchen,
                    label: 'Soup',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const SoupListScreen(
                      //             item: {
                      //               'name': 'Soup',
                      //               'image_url':
                      //                   'https://via.placeholder.com/150',
                      //             },
                      //           )),
                      // );
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.food_bank,
                    label: 'Swallow',
                    backgroundColor: Colors.orange.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.restaurant_menu,
                    label: 'Continental',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.local_dining,
                    label: 'Native',
                    backgroundColor: Colors.blue.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.soup_kitchen,
                    label: 'Stew',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.breakfast_dining,
                    label: 'Porridge',
                    backgroundColor: Colors.orange.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.restaurant_menu,
                    label: 'Continental',
                    backgroundColor: Colors.green.shade50,
                    onTap: () {},
                  ),
                  CategoryIcon(
                    icon: Icons.local_dining,
                    label: 'Native',
                    backgroundColor: Colors.blue.shade50,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
