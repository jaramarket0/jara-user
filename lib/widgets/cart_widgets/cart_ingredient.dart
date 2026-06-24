import 'dart:developer' as myLog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/grains_screen/grains_screen.dart';

import 'package:jara_market/widgets/custom_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

var controller = Get.find<CartController>();

class CartItemCard1 extends StatefulWidget {
  final int id;
  final String name;
  final String unit;
  final RxDouble basePrice;
  final double? originalPrice;
  final RxInt quantity;

  //final Funtion() updateUi;
  // final Function(int) addQuantity;
  // final Function(int) removeQuantity;
  final Function() updateUi;
  final Function() updateCustomPrice;
  final Function() addQuantity;
  final Function() removeQuantity;
  final VoidCallback onDeleteConfirmed;
  final TextEditingController textController;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final RxList<Ingredients> ingredients;

  const CartItemCard1({
    Key? key,
    required this.updateUi,
    required this.updateCustomPrice,
    required this.id,
    required this.name,
    required this.unit,
    required this.basePrice,
    this.originalPrice,
    required this.quantity,
    required this.addQuantity,
    required this.removeQuantity,
    required this.onDeleteConfirmed,
    required this.textController,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.ingredients,
  }) : super(key: key);

  @override
  State<CartItemCard1> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard1> {
  // TextEditingController textController = TextEditingController();
  int count = 0;
  double? result;
  double get totalPrice => widget.isSelected
      ? double.tryParse(widget.textController.text) ?? 0
      : widget.basePrice * widget.quantity.value;

  void _showDeleteConfirmationDialog(
      BuildContext context, int itemId, int ingredientId, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Item'),
          content: Text(
              'Are you sure you want to delete ${name.toUpperCase()} from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                controller.removeIngredient(itemId, ingredientId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog1(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to delete this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                controller.removeFromCart(itemId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddConfirmationDialog1(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add Item'),
          content: Text(
              'Do you want to add more ingredients to ${name.toUpperCase()} in your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // controller.removeFromCart(itemId);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => GrainsScreen(
                              forProduct: true,
                              ingredients: widget.ingredients,
                            )));
              },
              child: const Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.ingredients.isNotEmpty)
          Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  //  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return Text(
                            "${widget.ingredients.length} ingredients",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            weight: 5,
                            color: Colors.green,
                          ), //SvgPicture.asset('assets/images/add.svg'),
                          onPressed: () =>
                              _showAddConfirmationDialog1(context, widget.name),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Obx(() {
                        return Text(
                          '\u20A6${widget.ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.price! * ingredient.quantity!.value)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                      const Spacer(),
                      IconButton(
                        icon: SvgPicture.asset('assets/images/delete.svg'),
                        onPressed: () =>
                            _showDeleteConfirmationDialog1(context, widget.id),
                      ),
                      const SizedBox(width: 3),
                    ],
                  )
                ],
              )),
        Obx(() {
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
                                // widget.ingredients[index].isSelected.value
                                Builder(
                                  builder: (context) {
                                    final customPrice = double.tryParse(widget
                                        .ingredients[index].controller.text);
                                    final priceToShow = widget
                                            .ingredients[index]
                                            .isSelected
                                            .value &&
                                        customPrice != null;
                                    priceToShow
                                        ? customPrice
                                        : widget.ingredients[index].price! *
                                            widget.ingredients[index].quantity!
                                                .value;

                                    return widget.ingredients[index].isSelected
                                                .value &&
                                            customPrice != null
                                        ? Text(
                                            '\u20A6${customPrice.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          )
                                        : widget.ingredients[index].isSelected
                                                    .value &&
                                                widget.ingredients[index]
                                                    .controller.text.isEmpty
                                            ? Text(
                                                //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                                '\u20A6${(widget.ingredients[index].price! * widget.ingredients[index].quantity!.value).toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Obx(
                                                    () => Text(
                                                      '\u20A6${widget.ingredients[index].price! * widget.ingredients[index].quantity!.value}',
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  //if (widget.originalPrice != null) ...[

                                                  if (widget
                                                          .ingredients[index]
                                                          .controller
                                                          .text
                                                          .isEmpty &&
                                                      widget.ingredients[index]
                                                              .price! >
                                                          widget
                                                              .ingredients[
                                                                  index]
                                                              .basePrice!) ...[
                                                    const SizedBox(width: 8),
                                                    GestureDetector(
                                                      onTap: () {
                                                        myLog.log(
                                                            'base price : ${widget.ingredients[index].basePrice}, ingredient price: ${widget.ingredients[index].price}');
                                                      },
                                                      child: Text(
                                                        //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                                        '\u20A6${(widget.ingredients[index].basePrice)!.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              );
                                  },
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
                                    // Text(
                                    //   widget.unit,
                                    //   style: TextStyle(
                                    //     color: Color(0xff868D94),
                                    //     fontWeight: FontWeight.w400,
                                    //     fontSize: 12,
                                    //     fontFamily: 'Inter',
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Obx(() {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Checkbox(
                                            // focusColor: widget.ingredients[index].controller.text.isNotEmpty ? Colors.green : Colors.grey,
                                            activeColor: Colors.black,
                                            fillColor: !widget
                                                    .ingredients[index]
                                                    .controller
                                                    .text
                                                    .isEmpty
                                                ? WidgetStateProperty.all(
                                                    Colors.green)
                                                : null,
                                            side: const BorderSide(
                                              color: Color(
                                                  0xff868D94), // Change this to your desired stroke color
                                              width:
                                                  2, // Optional: stroke thickness
                                            ),
                                            checkColor: Colors.white,
                                            value: widget.ingredients[index]
                                                .isSelected.value,
                                            onChanged: (bool? value) {
                                              widget.onCheckboxChanged(value);
                                              setState(() {});
                                              setState(() {
                                                controller.toggleItemSelection(
                                                    widget.id,
                                                    widget
                                                        .ingredients[index].id);
                                              });

                                              // Clear custom price when unchecking
                                              if (value == false) {
                                                print('object');
                                                widget.ingredients[index]
                                                    .controller
                                                    .clear();
                                                controller.updateCustomPrice(
                                                    widget.id,
                                                    widget
                                                        .ingredients[index].id,
                                                    // widget.ingredients[index]
                                                    //     .price
                                                    //     .toString()
                                                    widget.textController.text);
                                              }
                                            }),
                                      );
                                    }),
                                    //SizedBox(width: 2,),
                                    !widget.ingredients[index].isSelected.value
                                        ? Text(
                                            'Custom Price',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                            ),
                                          )
                                        : Row(
                                            spacing: 3,
                                            children: [
                                              Text(
                                                'Click Here Again To Save Price',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 9,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              Icon(LucideIcons.info,
                                                  size: 12, color: Colors.grey)
                                            ],
                                          )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            //mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                // icon: const Icon(Icons.delete, color: Colors.red),
                                icon: SvgPicture.asset(
                                    'assets/images/delete.svg'),
                                onPressed: () => _showDeleteConfirmationDialog(
                                    context,
                                    widget.id,
                                    widget.ingredients[index].id,
                                    widget.ingredients[index].name!),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: widget
                                        .ingredients[index].isSelected.value
                                    ? Container(
                                        width: 119,
                                        height: 36,
                                        child: CustomTextField(
                                          keyboardType: TextInputType.number,
                                          controller: widget
                                              .ingredients[index].controller,
                                          onChanged: (p0) {
                                            print(p0);
                                            //setState(() {
                                            widget.updateCustomPrice();
                                            controller.update();
                                            //widget.updateUi();
                                            controller.calculatedServiceCharge;
                                            controller.totalIngredientPrice();
                                            controller
                                                .calculatedServiceChargeForIngredient;
                                            controller.total;
                                            controller.totalItems.value;
                                            controller.updateCustomPrice(
                                                widget.id,
                                                widget.ingredients[index].id,
                                                p0);
                                            //  });
                                          },
                                          hint: '25000',
                                          prefixIcon: Text('\u20A6'),
                                        ))
                                    : Row(
                                        children: [
                                          GestureDetector(onTap: () {
                                            if (widget.ingredients[index]
                                                    .quantity!.value >
                                                1) {
                                              controller
                                                  .decrementIngredientQuantity(
                                                      widget.id,
                                                      widget.ingredients[index]
                                                          .id);
                                            }
                                          }, child: Obx(() {
                                            return Container(
                                              margin: EdgeInsets.all(4),
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  color: widget
                                                              .ingredients[
                                                                  index]
                                                              .quantity!
                                                              .value ==
                                                          1
                                                      ? Colors.grey[100]
                                                      : Color(0xffFF9F0A)),
                                              child: Icon(
                                                Icons.remove,
                                                size: 15,
                                              ),
                                            );
                                          })),
                                          Obx(
                                            () => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                widget.ingredients[index]
                                                    .quantity!.value
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //widget.addQuantity();
                                              controller
                                                  .incrementIngredientQuantity(
                                                      widget.id,
                                                      widget.ingredients[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  color: Color(0xffFF9F0A)),
                                              child: Icon(
                                                Icons.add,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
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
