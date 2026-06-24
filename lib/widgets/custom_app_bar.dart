import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:jara_market/screens/cart_screen/cart_screen.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCart;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showCart = true,
    required this.onBackPressed,
    required MaterialColor titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          onBackPressed == null ? Navigator.pop(context) : onBackPressed!();
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (showCart)
          // IconButton(
          //   icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          //   onPressed: () {
          //     // TODO: Implement cart navigation
          //   },
          // ),
          GestureDetector(
            onTap: () {
              Get.to(() => const CartScreen());
            },
            child: Obx(() {
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
                child: SvgPicture.asset('assets/images/bag.svg'),
              );
            }),
          ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
