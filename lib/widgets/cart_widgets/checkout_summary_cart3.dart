import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';

import 'package:jara_market/widgets/custom_text_field.dart';

var controller = Get.find<CartController>();

class CartItemCard3 extends StatefulWidget {
  final int id;
  final String name;
  final String unit;
  final double basePrice;
  final double? originalPrice;
  final RxInt quantity;
  final TextEditingController textController;
  final bool isSelected;
  
  final RxList<Data> ingredients;
// int? id;
//   String? name;
//   String? description;
//   String? price;
//   String? unit;
//   String? stock;
//   String? imageUrl;
//   String? createdAt;

  const CartItemCard3({
    Key? key,
    required this.id,
    required this.name,
    required this.unit,
    required this.basePrice,
    this.originalPrice,
    required this.quantity,
    required this.textController,
    required this.isSelected,
    required this.ingredients,
  }) : super(key: key);

  @override
  State<CartItemCard3> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard3> {
  double get totalPrice => widget.isSelected
      ? double.tryParse(widget.textController.text) ?? 0
      : widget.basePrice * widget.quantity.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //     width: double.infinity,
        //     height: 50,
        //     decoration: BoxDecoration(
        //       color: Colors.grey.shade200,
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Center(
        //         child: Text(
        //       widget.name,
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //     ))),
        Obx((){
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                  Row(
                                      children: [
                                        Obx(
                                          () => Text(
                                            '\u20A6${widget.ingredients[index].price! * widget.ingredients[index].quantity!.value}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    widget.ingredients[index].name!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.unit,
                                    style: TextStyle(
                                      color: Color(0xff868D94),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Spacer(),
                                  Text('Qty: ${widget.ingredients[index].quantity}')
                                ],

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
        }),
      ],
    );
  }
}
