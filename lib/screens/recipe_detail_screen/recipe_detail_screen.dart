import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/recipe_detail_screen/controller/recipe_detail_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/image_carousel.dart';

RecipeDetailController controller = Get.put(RecipeDetailController());

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Egusi Soup',
        titleColor: Colors.orange,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(
              images: [
                'egusi_soup_image_url_here',
                // Add more image URLs
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Egusi Soup',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.orange),
                          Text('4.3 (41)'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildIngredientsList(),
                  const SizedBox(height: 24),
                  const Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    style: TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Watch Video'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Get Ingredient'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    final ingredients = [
      'Egusi',
      'Crayfish',
      'Assorted meat',
      '2 Stock fish',
      '2 Dry fish',
      'Scotch bonnet',
      '1 large onion bulb',
      'Black pepper',
      '2 Calabar nutmeg',
      '4 Seasoning cubes',
      '1/2 tsp Salt',
      'Palm oil',
      'Beef seasoning',
      'Dry ginger or fresh ginger',
      '3 garlic clove',
      '2 cups water',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '${index + 1}. ${ingredients[index]}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}