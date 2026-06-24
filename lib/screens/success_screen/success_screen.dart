import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/success_screen/controller/success_controller.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary_card.dart';
import 'package:jara_market/widgets/cart_widgets/checkout_summary_cart3.dart';
import 'package:jara_market/widgets/custom_button.dart';
// import '../../widgets/cart_product_card.dart';

SuccessController controller = Get.put(SuccessController());
var cartController = Get.find<CartController>();

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 100,
                  child: CustomButton(
                    isOutlined: true,
                    text: 'View Receipt',
                    onPressed: () {
                     // _re
                    },
                  ),
                ),
                // SizedBox(
                //   height: 40,
                //   width: 100,
                //   child: CustomButton(
                //     isOutlined: true,
                //     text: 'View Receipt',
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 40),
            SvgPicture.asset('assets/images/check.svg'),
            const SizedBox(height: 20),
            const Text(
              'Successful',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView(padding: const EdgeInsets.all(16), children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartController.cartItems.length + 1,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == cartController.cartItems.length) {
                      return cartController.ingredientList.length == 0
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //  const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ingredients',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height:
                                      (cartController.ingredientList.length *
                                              110.0)
                                          .clamp(0.0, 300.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return CartItemCard3(
                                                id: cartController
                                                    .ingredientList[index].id!,
                                                ingredients: cartController
                                                    .ingredientList,
                                                name: cartController
                                                    .ingredientList[index]
                                                    .name!,
                                                unit: cartController
                                                        .ingredientList[index]
                                                        .description ??
                                                    'N/A',
                                                basePrice: cartController
                                                    .ingredientList[index]
                                                    .price!,
                                                quantity: cartController
                                                    .ingredientList[index]
                                                    .quantity!,
                                                textController:
                                                    TextEditingController(
                                                  text: (cartController
                                                          .ingredientList[index]
                                                          .quantity)
                                                      .toString(),
                                                ),
                                                isSelected: false,
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                                      height: 0.5,
                                                      color: Color.fromARGB(
                                                          57, 228, 228, 228),
                                                    ),
                                            itemCount: cartController
                                                .ingredientList.length),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                    }
                    final item = cartController.cartItems[index];
                    final ingredients = item.ingredients;
                    return CartItemCard2(
                      id: item.id,
                      ingredients: ingredients,
                      name: item.name,
                      unit: item.description,
                      basePrice: item.price,
                      quantity: item.quantity,
                      textController: TextEditingController(
                        text: (item.quantity).toString(),
                      ),
                      isSelected: false,
                    );
                  },
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartSummary(
                    itemsCost: cartController.totalIngredientPrice,
                    mealCost: cartController.mealPrepPrice,
                    serviceCharge: cartController.calculatedServiceCharge,
                    shippingCost: cartController.shippingCost.value,
                    totalAmount: cartController.total.obs,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tracking ID: YT87FE63IH29',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cartController.cartItems.clear();
                            cartController.ingredientList.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                            );
                          },
                          icon: null,
                          label: const Text(
                            'Continue Shopping',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff666666)),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    width: 1, color: Color(0xff9F9F9F))),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // to implement tracking my order here
                            cartController.cartItems.clear();
                            cartController.ingredientList.clear();
                          },
                          //   : null,
                          child: const Text(
                            'Track My Order',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff090909)),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
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
}
