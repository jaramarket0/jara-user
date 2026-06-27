import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

var controller = Get.put(CartController());

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF212429),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                'assets/images/img_nav_home_unselected.svg'), //Icon(Icons.home_outlined),
            activeIcon: SvgPicture.asset(
                'assets/images/img_nav_home_selected.svg'), //Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // badgeStyle: badges.BadgeStyle(
              //   badgeColor: Colors.grey,
              //   padding: EdgeInsets.all(4),
              // ),
              child: Icon(
                LucideIcons.bubbles,
                weight: 0.1,
              ),
            ),
            activeIcon: badges.Badge(
              badgeContent: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // badgeStyle: badges.BadgeStyle(
              //   badgeColor: Colors.grey,
              //   padding: EdgeInsets.all(4),
              // ),
              child: Icon(
                LucideIcons.bubbles,
                weight: 0.1,
              ),
            ),
            label: 'Ai Meal',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              return badges.Badge(
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.grey,
                  padding: EdgeInsets.all(4),
                ),
                showBadge: true,
                badgeContent: Text(
                  (Get.find<CartController>().cartItems.length +
                          Get.find<CartController>().ingredientList.length)
                      .toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  weight: 0.01,
                ),
              );
            }),
            activeIcon: Obx(() {
              return badges.Badge(
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.black,
                  padding: EdgeInsets.all(4),
                ),
                showBadge: true,
                badgeContent: Text(
                  (Get.find<CartController>().cartItems.length +
                          Get.find<CartController>().ingredientList.length)
                      .toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  weight: 0.01,
                ),
              );
            }),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
