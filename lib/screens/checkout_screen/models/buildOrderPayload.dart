import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';
Map<String, dynamic> buildOrderPayload({
  required List<CartItem> cartItems,
  List<Data>? ingredient,
  required String orderDate,
  required int addressId,
  required String deliveryType, // e.g., 'pickup' or 'walkin'
  required double shippingFee,
  required double serviceCharge,
  required double vat,
  required String remarks,
  String? audio_url,
}) {
  // Extract product list
  List<Map<String, dynamic>> products = cartItems.map((item) {
    return {
      "product_id": item.id,
      "quantity": item.quantity.value,
      "price": item.price, // or item.originalPrice ?? item.price
    };
  }).toList();

  // // Extract selected ingredients from all cart items
  // List<Map<String, dynamic>> ingredients = cartItems
  //     .expand((item) => item.ingredients)
  //     .where((ing) => ing.isSelected.value)
  //     .map((ing) => {
  //           "ingredient_id": ing.id,
  //           "quantity": ing.quantity?.value ?? 1,
  //           "unit": ing.unit ?? "unit", // fallback if unit is null
  //           "price": ing.price ?? 0,
  //         })
  //     .toList();

    // Extract selected ingredients from all cart items
  List<Map<String, dynamic>> ingredients = ingredient!.map((ing){
      return {
            "ingredient_id": ing.id,
            "quantity": ing.quantity?.value ?? 1,
            "unit": ing.unit ?? "unit", // fallback if unit is null
            "price": ing.price ?? 0,    
      };
}).toList();

  // Calculate total (products + selected ingredients)
  double total = products.fold(0.0, (sum, p) => sum + (p['price'] * p['quantity'])) +
      ingredients.fold(0.0, (sum, i) => sum + (i['price'] * i['quantity'])) +
      serviceCharge +
      vat +
      shippingFee;

  return {
    "order_date": orderDate,
    "shipping_fee": shippingFee.toStringAsFixed(0),
    "delivery_type": deliveryType,
    "address_id": addressId,
    "service_charge": serviceCharge,
    "products": products,
    "ingredients": ingredients,
    "vat": vat,
    "total": total,
    "remarks": remarks,
    "audio_url": audio_url,
  };
}
