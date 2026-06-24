// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:jara_market/screens/favorites_screen/controller/favorites_controller.dart';
// import '../../models/food_item.dart';
// import '../../widgets/food_item_card.dart';
// import '../../services/api_service.dart';
// import '../../services/favorites_service.dart';
// import '../../services/cart_service.dart';

// FavoritesController controller = Get.put(FavoritesController());

// class FavoritesScreen extends StatefulWidget {
//   const FavoritesScreen({super.key});

//   @override
//   State<FavoritesScreen> createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   // ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
//   // final FavoritesService _favoritesService = FavoritesService();
//   // final CartService _cartService = CartService();

//   void showMoreOptionsBottomSheet(BuildContext context, FoodItem item) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading:
//                     const Icon(Icons.shopping_cart, color: Color(0xFFFFAA00)),
//                 title: const Text('Add to Cart'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.addToCart(item);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete, color: Colors.red),
//                 title: const Text('Remove from Favorites'),
//                 onTap: () async {
//                   try {
//                     await controller.removeFavorite(int.parse(item.id));
//                     Navigator.pop(context);
//                     controller.fetchFavorites(); // Refresh the list
//                     // if (mounted) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     const SnackBar(
//                     //       content: Text('Removed from favorites'),
//                     //       duration: Duration(seconds: 1),
//                     //     ),
//                     //   );
//                     // }
//                   } catch (e) {
//                     Navigator.pop(context);
//                     // if (mounted) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     SnackBar(
//                     //       content: Text('Failed to remove: $e'),
//                     //       backgroundColor: Colors.red,
//                     //     ),
//                     //   );
//                     // }
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchFavorites();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         leading: Icon(Icons.chevron_left_rounded),
//         title: Text(
//                   'Favorites',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               Expanded(
//                 child: controller.isLoading.value
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Color(0xFFFFAA00)),
//                         ),
//                       )
//                     : controller.favourite.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.favorite_border,
//                                   size: 64,
//                                   color: Colors.grey[400],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'No favorites yet',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Items you favorite will appear here',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[500],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: controller.favourite.length,
//                             itemBuilder: (context, index) {
//                               final item = controller.favouriteItems[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: FoodItemCard(
//                                   item: item,
//                                   onAddToCart: () => controller.addToCart(item),
//                                   onMoreOptions: () {
//                                     showMoreOptionsBottomSheet(context, item);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
// ENTRY POINT — replaces FavoritesScreen
// ─────────────────────────────────────────────
class AIMealPrepFlow extends StatefulWidget {
  const AIMealPrepFlow({super.key});

  @override
  State<AIMealPrepFlow> createState() => _AIMealPrepFlowState();
}

class _AIMealPrepFlowState extends State<AIMealPrepFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Step1HealthInfo(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            onBack: _prevStep,
            onNext: _nextStep,
          ),
          Step2MealResult(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            onBack: _prevStep,
            onNext: _nextStep,
          ),
          Step3AlternativeMeals(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            onBack: _prevStep,
            onNext: _nextStep,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgressBar({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: index <= currentStep
                      ? const Color(0xFFFFAA00)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _AppBarSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const _AppBarSection({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child:
                const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _StepProgressBar(currentStep: currentStep, totalSteps: totalSteps),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OrangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;

  const _OrangeButton({
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFFFFAA00),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 1 — Tell Us About Your Health
// ─────────────────────────────────────────────

class Step1HealthInfo extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const Step1HealthInfo({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<Step1HealthInfo> createState() => _Step1HealthInfoState();
}

class _Step1HealthInfoState extends State<Step1HealthInfo> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedCondition = 'Diabetes';
  double _waterIntake = 0.5;
  String _selectedFoodPref = 'Continental';

  final List<String> _healthConditions = [
    'Diabetes',
    'High Blood Pressure',
    'Ulcer',
    'Weight Loss Goal',
    'Weight Gain Goal',
    'Gym/Bodybuilding',
    'None',
  ];

  final List<String> _foodPreferences = [
    'Continental',
    'African',
    'Vegetarian',
    'Keto',
    'Low Carb',
  ];

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
      );

  Widget _radioOption(
      String label, String groupValue, ValueChanged<String> onChanged) {
    final selected = groupValue == label;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFFFAA00) : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFAA00),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 32, color: Color(0xFFEEEEEE));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _AppBarSection(
            title: 'Tell Us About\nYour Health',
            subtitle: '',
            onBack: widget.onBack,
            currentStep: widget.currentStep,
            totalSteps: widget.totalSteps,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Age + Gender
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Age',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '18',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Gender',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                    ),
                                    items: ['Male', 'Female', 'Other']
                                        .map((g) => DropdownMenuItem(
                                            value: g, child: Text(g)))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedGender = val!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Weight (kg)',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _weightController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '30',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Height (cm)',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _heightController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '170',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEE))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _divider(),

                  // Health Conditions
                  _sectionLabel('Health Conditions'),
                  ..._healthConditions.map((c) => _radioOption(
                        c,
                        _selectedCondition,
                        (val) => setState(() => _selectedCondition = val),
                      )),

                  _divider(),

                  // Daily Water Intake
                  _sectionLabel('Daily Water Intake'),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFFFAA00),
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      thumbColor: const Color(0xFFFFAA00),
                      overlayColor: const Color(0xFFFFAA00).withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _waterIntake,
                      min: 0,
                      max: 1,
                      onChanged: (val) => setState(() => _waterIntake = val),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Low',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Moderate',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Active',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),

                  _divider(),

                  // Food Preference
                  _sectionLabel('Food Preference'),
                  ..._foodPreferences.map((f) => _radioOption(
                        f,
                        _selectedFoodPref,
                        (val) => setState(() => _selectedFoodPref = val),
                      )),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _OrangeButton(
              label: 'Generate My Smart Meal Plan',
              onTap: widget.onNext,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 2 — Your Smart Meal for Today
// ─────────────────────────────────────────────

class Step2MealResult extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const Step2MealResult({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<Step2MealResult> createState() => _Step2MealResultState();
}

class _Step2MealResultState extends State<Step2MealResult> {
  int _imageIndex = 0;
  bool _isFavourited = false;

  final List<String> _placeholderImages = [
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600',
    'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600',
  ];

  Widget _badge(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _healthTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFAA00)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF333333)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _AppBarSection(
            title: 'Your Smart Meal\nfor Today',
            subtitle: 'Victor, lorem ipsum dolor sit amet, consectetur',
            onBack: widget.onBack,
            currentStep: widget.currentStep,
            totalSteps: widget.totalSteps,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: _placeholderImages.length,
                      onPageChanged: (i) => setState(() => _imageIndex = i),
                      itemBuilder: (context, index) {
                        return Image.network(
                          _placeholderImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.fastfood,
                                size: 60, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  // Dots
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_placeholderImages.length, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _imageIndex ? 10 : 8,
                        height: i == _imageIndex ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _imageIndex
                              ? const Color(0xFF1A5AFF)
                              : const Color(0xFFCCCCCC),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Meal name + rating
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            'Grilled Chicken + Steamed Veg + Brown Rice',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFAA00).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Color(0xFFFFAA00)),
                              const SizedBox(width: 4),
                              const Text('8.9/10',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFAA00),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Badges
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _badge(Icons.no_food_outlined, 'Low Sodium',
                            const Color(0xFFFF6B35)),
                        _badge(Icons.favorite, 'Heart friendly', Colors.red),
                        _badge(Icons.local_fire_department, '620 kcal',
                            const Color(0xFFFF6B35)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),

                  // Why this meal
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Why This Meal?',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 10),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF444444),
                              height: 1.5),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF444444),
                              height: 1.5),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF444444),
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Color(0xFFEEEEEE)),

                  // Health Tips
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Health Tips',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 12),
                        _healthTip(Icons.water_drop_outlined,
                            'Drink 2.5L water today'),
                        _healthTip(Icons.directions_walk,
                            '20 mins evening walk recommended'),
                        _healthTip(Icons.no_food, 'Reduce salt intake today'),
                        const SizedBox(height: 6),
                        const Text(
                          '(These tips are condition-based)',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: _OrangeButton(
                      label: 'Get Ingredient', onTap: widget.onNext),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OrangeButton(
                    label: 'Swap Meal',
                    onTap: () {},
                    color: const Color(0xFFE0E0E0),
                    textColor: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => _isFavourited = !_isFavourited),
                  child: Icon(
                    _isFavourited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavourited ? Colors.red : const Color(0xFFFFAA00),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 3 — Want Something Different?
// ─────────────────────────────────────────────

class Step3AlternativeMeals extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const Step3AlternativeMeals({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<Step3AlternativeMeals> createState() => _Step3AlternativeMealsState();
}

class _Step3AlternativeMealsState extends State<Step3AlternativeMeals> {
  String _selectedFilter = 'Low Budget';
  final Set<int> _favourited = {};

  final List<String> _filters = [
    'Low Budget',
    'High Protein',
    'Vegetarian',
    'Fast Prep',
    'Under 500 kcal',
  ];

  final List<Map<String, dynamic>> _meals = [
    {
      'name': 'Afang Soup',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut',
      'price': '₦20,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
    },
    {
      'name': 'Grilled Chicken + Steamed Veg + Brown Rice',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'price': '₦45,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    },
    {
      'name': 'Grilled Chicken + Steamed Veg + Brown Rice',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'price': '₦45,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
    },
    {
      'name': 'Afang Soup',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut',
      'price': '₦20,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
    },
    {
      'name': 'Afang Soup',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut',
      'price': '₦20,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
    },
    {
      'name': 'Grilled Chicken + Steamed Veg + Brown Rice',
      'tags': 'Low Sodium • Heart friendly • 620 kcal',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'price': '₦45,000',
      'rating': '8.9/10',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _AppBarSection(
            title: 'Want Something\nDifferent?',
            subtitle: 'Victor, lorem ipsum dolor sit amet, consectetur',
            onBack: widget.onBack,
            currentStep: widget.currentStep,
            totalSteps: widget.totalSteps,
          ),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._filters.map((f) {
                  final selected = _selectedFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            selected ? const Color(0xFFFFAA00) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFFFAA00)
                              : const Color(0xFFDDDDDD),
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              selected ? Colors.white : const Color(0xFF333333),
                        ),
                      ),
                    ),
                  );
                }),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child:
                      const Icon(Icons.tune, size: 18, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Grid of meals
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                final fav = _favourited.contains(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            meal['image'],
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 140,
                              color: Colors.grey[200],
                              child: const Icon(Icons.fastfood,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              fav
                                  ? _favourited.remove(index)
                                  : _favourited.add(index);
                            }),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                fav ? Icons.favorite : Icons.favorite_border,
                                size: 16,
                                color: fav ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal['name'],
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A)),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal['tags'],
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFFFF6B35)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal['desc'],
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meal['price'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFAA00).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 12, color: Color(0xFFFFAA00)),
                              const SizedBox(width: 2),
                              Text(meal['rating'],
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFFFAA00),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 4 — Your Weekly Smart Plan
// ─────────────────────────────────────────────

class Step4WeeklyPlan extends StatelessWidget {
  final VoidCallback onBack;

  const Step4WeeklyPlan({super.key, required this.onBack});

  static const List<String> _days = [
    'MON',
    'TUES',
    'WED',
    'THUR',
    'FRI',
    'SAT',
    'SUN'
  ];

  static const List<Map<String, dynamic>> _mealColors = [
    {
      'label': 'Breakfast',
      'color': Color(0xFFDFF3D4),
      'dot': Color(0xFF4CAF50)
    },
    {'label': 'Lunch', 'color': Color(0xFFD4DCF3), 'dot': Color(0xFF3A5BCC)},
    {'label': 'Dinner', 'color': Color(0xFFFFF0D4), 'dot': Color(0xFFFFAA00)},
  ];

  Widget _mealCell(Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lorem Ipsum',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dol ore magna aliqua.',
            style: TextStyle(
                fontSize: 8,
                color: Colors.black.withOpacity(0.55),
                height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const Text('2.5%',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A))),
              ],
            ),
            const SizedBox(height: 8),
            // Placeholder sparkline
            CustomPaint(
              size: const Size(double.infinity, 30),
              painter: _SparklinePainter(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.chevron_left, size: 28),
                ),
                const SizedBox(height: 8),
                const Text('Your Weekly Smart Plan',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                const Text('Victor, lorem ipsum dolor sit amet, consectetur',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),
                // Full progress bar (all steps done)
                Row(
                  children: List.generate(
                      3,
                      (i) => Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFAA00),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _mealColors.map((m) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: m['dot'] as Color)),
                      const SizedBox(width: 6),
                      Text(m['label'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF333333))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Weekly table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ..._days.map((day) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(day,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF555555))),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: _mealColors.map((m) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: _mealCell(m['color'] as Color),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 16),

                  // Stats cards
                  Row(
                    children: [
                      _statCard(Icons.local_fire_department, '150',
                          'Average Daily Calories', Colors.orange),
                      const SizedBox(width: 12),
                      _statCard(Icons.no_food, '1,500', 'Sodium Trend',
                          Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statCard(Icons.water_drop_outlined, '150',
                          'Water Reminder Compliance', Colors.blue),
                      const SizedBox(width: 12),
                      _statCard(Icons.directions_walk, '150',
                          'Weight Projection', Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: _OrangeButton(
                      label: 'Get Weekly Auto Plan', onTap: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OrangeButton(
                    label: 'Add to Cart (All Ingredients)',
                    onTap: () {},
                    color: const Color(0xFFE0E0E0),
                    textColor: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sparkline painter for stat cards
class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFAA00)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final points = [0.8, 0.4, 0.7, 0.3, 0.6, 0.5, 0.9];
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => false;
}
