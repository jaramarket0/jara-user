import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/screens/main_screen/controller/main_controller.dart';
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
    cartController = Get.put(CartController());
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
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  void _onTabTapped(int index) {
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
