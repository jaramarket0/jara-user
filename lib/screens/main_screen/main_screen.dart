import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/screens/main_screen/controller/main_controller.dart';
import 'package:jara_market/screens/orders_screen/orders_screen.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../home_screen/home_screen.dart';
import '../favorites_screen/favorites_screen.dart';
import '../cart_screen/cart_screen.dart';
import '../profile_screen/profile_screen.dart';

MainController controller = Get.put(MainController());
DataBase dataBase = Get.find<DataBase>();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HomeController controller = Get.put(HomeController());
  late CartController cartController;

  initState() {
    super.initState();
    controller.fetchFoodCategoriesByCondition();
    cartController = Get.find<CartController>();
    //controller.fetchFoods();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const AIMealPrepFlow();
      case 2:
        return const CartScreen();
      case 3:
        return const OrdersScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  /// Meal Plan is the one tab with nothing behind it yet.
  static const int _mealPlanTabIndex = 1;

  /// Explains that Meal Plan isn't ready instead of opening an unfinished
  /// screen. Neither the barrier nor the back button closes it, so it can
  /// only go away through its own button.
  Future<void> _showMealPlanComingSoon() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Coming Soon',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'AI Meal Plan isn\'t ready just yet. We\'ll let you know as soon '
            'as it is.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFFAA00)),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index == _mealPlanTabIndex) {
      // Leave the selection where it was so the customer stays on whatever
      // they were looking at rather than landing on an empty tab.
      _showMealPlanComingSoon();
      return;
    }
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _getCurrentScreen(),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
