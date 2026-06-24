import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
var controller = Get.find<CartController>();
class CartSummary extends StatelessWidget {
  final double shippingCost;
  final RxDouble totalAmount;
  final RxDouble itemsCost;
  final double mealCost;
  final double serviceCharge;

  const CartSummary({
    super.key,
    required this.shippingCost,
    required this.totalAmount,
    required this.itemsCost,
    required this.mealCost,
    required this.serviceCharge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //items cost row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx((){
              return Text(
              '\u20A6${controller.totalItems.value.toStringAsFixed(2)}',
            //  '\u20A6${itemsCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            );
            })
          ],
        ),
        //meal cost row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Meal Preparation',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\u20A6${mealCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // service charge row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Service Charge',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx((){
              return Text(
              '\u20A6${(controller.calculatedServiceCharge).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            );
            })
          ],
        ),
        // Shipping cost row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shipping',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\u20A6${shippingCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Total amount row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  ' VAT included',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                ],)
              ],
            ),

            Obx((){
              return Text(
              '\u20A6${controller.total.toInt()}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
              ),
              );
            })
            
          ],
        ),
      ],
    );
  }
}