import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
// import 'package:jara_market/screens/home_screen/models/models.dart';
// import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';
import 'package:jara_market/widgets/custom_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

var controller = Get.find<CartController>();

class CartItemCard extends StatefulWidget {
  final String name;
  final String unit;
  final Rx<Data> ingredientObject;
  final double basePrice;
  final double? originalPrice;
  final RxInt quantity;
  final String ingredientLenght;
  // final Function(int) addQuantity;
  // final Function(int) removeQuantity;
  final Function() addQuantity;
  final Function() customPrice;
  final Function() updateUi;
  final Function() removeQuantity;
  final VoidCallback onDeleteConfirmed;
  final TextEditingController textController;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final List<Data> ingredients;

  const CartItemCard({
    Key? key,
    required this.ingredientObject,
    required this.ingredientLenght,
    required this.name,
    required this.unit,
    required this.updateUi,
    required this.basePrice,
    required this.customPrice,
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
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  double get totalPrice => widget.ingredientObject.value.isSelected!.value
      ? double.tryParse(widget.textController.text) ?? 0
      : widget.ingredientObject.value.price! *
          widget.ingredientObject.value.quantity!.value;

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to delete this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                widget.onDeleteConfirmed(); // Call the delete callback
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.ingredientObject.value.isSelected!.value
                            ? Text(
                                //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                '\u20A6${(widget.ingredientObject.value.price! * widget.ingredientObject.value.quantity!.value).toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14,
                                ),
                              )
                            : Row(
                                children: [
                                  Obx(
                                    () => Row(
                                      children: [
                                        Text(
                                          '\u20A6${totalPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        !widget
                                                    .ingredientObject
                                                    .value
                                                    .controller
                                                    .text
                                                    .isNotEmpty &&
                                                (widget.ingredientObject.value
                                                        .price! >
                                                    widget.ingredientObject
                                                        .value.basePrice!)
                                            ? Text(
                                                //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                                '\u20A6${(widget.ingredientObject.value.basePrice ?? 0.0).toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : (widget.ingredientObject.value
                                                        .controller.text ==
                                                    widget.ingredientObject
                                                        .value.basePrice)
                                                ? SizedBox.shrink()
                                                : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  //if (widget.originalPrice != null) ...[
                                  if (widget.ingredientObject.value.isSelected!
                                      .value) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                      '\u20A6${(widget.ingredientObject.value.price! * widget.ingredientObject.value.quantity!.value).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              widget.name,
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
                          ],
                        ),
                        Row(
                          children: [
                            // Checkbox(
                            //  // fillColor: MaterialStateProperty.all(Colors.green),
                            //   overlayColor: MaterialStateProperty.all(Colors.grey),
                            //   focusColor: Colors.grey,
                            //   activeColor: Colors.black,
                            //   side: const BorderSide(
                            //     color: Color(0xff868D94), // Change this to your desired stroke color
                            //     width: 2,          // Optional: stroke thickness
                            //   ),
                            //   checkColor: Colors.white,
                            //   value: isSelected, onChanged: (bool? value) {
                            //     widget.onCheckboxChanged(value);
                            //     setState(() {
                            //       isSelected = value ?? false;
                            //     });
                            //   }),
                            //SizedBox(width: 2,),

                            Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Checkbox(
                                    // focusColor: widget.ingredients[index].controller.text.isNotEmpty ? Colors.green : Colors.grey,
                                    activeColor: widget.ingredientObject.value
                                            .controller.text.isEmpty
                                        ? Colors.black
                                        : Colors.green,
                                    fillColor: !widget.ingredientObject.value
                                            .controller.text.isEmpty
                                        ? WidgetStateProperty.all(Colors.green)
                                        : null,
                                    side: const BorderSide(
                                      color: Color(
                                          0xff868D94), // Change this to your desired stroke color
                                      width: 2, // Optional: stroke thickness
                                    ),
                                    checkColor: Colors.white,
                                    value: widget.ingredientObject.value
                                        .isSelected!.value,
                                    onChanged: (bool? value) {
                                      widget.onCheckboxChanged(value);
                                      setState(() {});
                                      print('object');
                                      setState(() {
                                        controller.update();
                                        controller
                                            .toggleItemSelectionIngredient(
                                                widget.ingredientObject.value
                                                    .id!);
                                      });

                                      // Clear custom price when unchecking
                                      if (value == false) {
                                        widget.ingredientObject.value.controller
                                            .clear();
                                        controller.updateCustomPriceIngredient(
                                            widget.ingredientObject.value.id!,
                                            '0');
                                      }
                                    }),
                              );
                            }),

                            !widget.ingredientObject.value.isSelected!.value
                                ? Text(
                                    'Custom Price',
                                    style: TextStyle(
                                      color: Colors.grey[900],
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
                        icon: SvgPicture.asset('assets/images/delete.svg'),
                        onPressed: () => _showDeleteConfirmationDialog(context),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: widget.ingredientObject.value.isSelected!.value
                            ? Container(
                                width: 119,
                                height: 36,
                                child: CustomTextField(
                                  keyboardType: TextInputType.number,
                                  controller:
                                      widget.ingredientObject.value.controller,
                                  hint: '25000',
                                  prefixIcon: Text('\u20A6'),
                                  onChanged: (p0) {
                                    setState(() {
                                      controller.update();
                                      widget.updateUi();
                                      widget.customPrice();

                                      controller.updateCustomPriceIngredient(
                                          widget.ingredientObject.value.id!,
                                          p0);
                                    });
                                    controller.updateCustomPriceIngredient(
                                        widget.ingredientObject.value.id!, p0);
                                  },
                                ))
                            : Row(
                                children: [
                                  GestureDetector(onTap: () {
                                    if (widget.quantity.value > 1) {
                                      //  widget.removeQuantity(widget.quantity - 1);
                                      widget.removeQuantity();
                                    }
                                  }, child: Obx(() {
                                    return Container(
                                      margin: EdgeInsets.all(4),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          color: widget.quantity.value == 1
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        widget.quantity.value.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.addQuantity();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
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
          );
        }));
  }
}
