import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';

ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

class CartController extends GetxController {
  TextEditingController messageController = TextEditingController();

  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxList<Data> ingredientList = <Data>[].obs;

  RxBool isSet = false.obs;
  RxDouble? itemsCost;
  var mealCost = 0.0.obs;
  var serviceChargeValue = 0.0.obs;
  var shippingCost = 2000.0.obs;
  var totalAmount = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool mealPrep = false.obs;
  RxBool updatePrice = false.obs;
  RxDouble shippingCost1 = 1500.0.obs;

  void updateCosts({
    double? items,
    double? meal,
    double? service,
    double? shipping,
    double? total,
  }) {
    if (items != null) itemsCost!.value = items;
    if (meal != null) mealCost.value = meal;
    if (service != null) serviceChargeValue.value = service;
    if (shipping != null) shippingCost.value = shipping;
    if (total != null) totalAmount.value = total;
  }

  void addToCart(CartItem item) {
    print(item.name);
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    print('Index found: $index');
    if (index == -1) {
      cartItems.add(item);
      print(cartItems.length);
      print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
    } else {
      cartItems[index].quantity += item.quantity.value;
      print(cartItems.length);
      print(cartItems[index].quantity);
    }
    // print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
  }

  void addIngredientToCart(Data item) {
    print(item.name);
    int index = ingredientList
        .indexWhere((ingredientItem) => ingredientItem.id == item.id);
    print('Index found: $index');
    if (index == -1) {
      ingredientList.add(item);
      print(ingredientList.length);
      isSet.value = true;
      print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
    } else {
      if (ingredientList[index].stock != null) {
        ingredientList[index].quantity =
            ingredientList[index].quantity! + item.quantity!.value;
      }
      print(ingredientList.length);
      print(ingredientList[index].quantity);
    }
    // print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
  }

  void removeFromCart(int itemId) {
    print('removing $itemId');
    cartItems.removeWhere((item) => item.id == itemId);
  }

  // void removeFromCart(int itemId) {
  //   print('removing $itemId');
  //   cartItems.removeWhere((item) => item.id == itemId);
  // }

  void removeIngredientFromCart(int itemId) {
    print('removing $itemId');
    ingredientList.removeWhere((item) => item.id == itemId);
  }

  void deleteIngredientList() {
    ingredientList.clear();
  }

  void updateItemQuantity(int itemId, int quantity) {
    print(quantity);
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity.value = quantity;
      }
    }
  }

// Add a single method to recalculate all of them:
  void recalculateTotals() {
    totalIngredientPrice.value = cartItems.fold<double>(
      0.0,
      (sum, item) =>
          sum +
          item.ingredients.fold<double>(
            0.0,
            (s, ing) => s + (ing.price! * ing.quantity!.value),
          ),
    );

    totalIngredientPriceForIngredient.value = ingredientList.fold<double>(
      0.0,
      (s, ing) => s + (ing.price! * ing.quantity!.value),
    );

    totalItems.value =
        totalIngredientPrice.value + totalIngredientPriceForIngredient.value;
  }

  void updateIngredientQuantity(int itemId, int quantity) {
    print(quantity);
    int index = ingredientList.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        ingredientList.removeAt(index);
      } else {
        //  myLog.log("====================${ingredientList[index].quantity!.value}");
        ingredientList[index].quantity!.value = quantity;
      }
    }
  }

  void updateIngredientUi(int itemId, int quantity) {
    print(quantity);
    int index = ingredientList.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        ingredientList.removeAt(index);
      } else {
        myLog.log(
            "====================${ingredientList[index].quantity!.value}");
        ingredientList[index].quantity!.value += quantity;
        ingredientList[index].quantity!.value -= quantity;
      }
    }
  }

  void updateCartItemUi(int itemId, int ingredientId, int quantity) {
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      //cartItems[index].ingredients = updatedItem.ingredients;
      int ingredientIndex = cartItems[index]
          .ingredients
          .indexWhere((ingredient) => ingredient.id == ingredientId);
      if (ingredientIndex != -1) {
        if (quantity <= 0) {
          cartItems[index].ingredients.removeAt(ingredientIndex);
        } else {
          cartItems[index].ingredients[ingredientIndex].quantity!.value +=
              quantity;
          cartItems[index].ingredients[ingredientIndex].quantity!.value -=
              quantity;
        }
      } else {
        print('Ingredient with id $ingredientId not found in item $itemId.');
      }
    } else {
      print('Item with id $itemId not found in cart.');
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  double get totalPrice {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  double get mealPrepPrice {
    return mealPrep.value ? 2000.00 : 0.00;
  }

  RxDouble get shippingCost2 {
    return itemsCost! > 0.0 ? 2000.0.obs : 0.0.obs;
  }

  void updateShippingCost() {
    if (itemsCost != null && itemsCost!.value > 0) {
      shippingCost1.value = 2000.0;
    } else {
      shippingCost1.value = 0.0;
    }
  }

// double get calculatedServiceCharge{
//   return calculatedServiceChargeForFood + (ingredientList.isNotEmpty ? calculatedServiceCharge : 0.0 ) ;
// }

  double get calculatedServiceCharge {
    return ((totalItems) * 0.10) < 1000.0
        ? 1000.0
        : (totalIngredientPrice.value * 0.10);
  }

  double get calculatedServiceChargeForIngredient {
    return (totalIngredientPriceForIngredient.value * 0.10) < 1000.0
        ? 1000.0
        : (totalIngredientPrice.value * 0.10);
  }

  RxDouble get totalIngredientPrice {
    final total = cartItems.fold<double>(
      0.0,
      (sum, item) =>
          sum +
          item.ingredients.fold<double>(
            0.0,
            (ingredientSum, ingredient) =>
                ingredientSum +
                (ingredient.price! * ingredient.quantity!.value),
          ),
    );
    return total.obs;
  }

  RxDouble get totalIngredientPriceForIngredient {
    final total = ingredientList.fold<double>(
      0.0,
      (ingredientSum, ingredient) =>
          ingredientSum + (ingredient.price! * ingredient.quantity!.value),
    );
    return total.obs;
  }

  RxDouble get totalItems {
    return (totalIngredientPriceForIngredient.value +
            totalIngredientPrice.value)
        .obs;
  }

  double get total {
    return totalIngredientPrice.value +
        mealPrepPrice +
        calculatedServiceCharge +
        shippingCost.value +
        (ingredientList.isNotEmpty
            ? totalIngredientPriceForIngredient.value
            : 0.0);
  }

  void incrementIngredientQuantity(int itemId, int ingredientId) {
    // Find the cart item
    final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final cartItem = cartItems[itemIndex];

      // Find the ingredient
      final ingredientIndex =
          cartItem.ingredients.indexWhere((ing) => ing.id == ingredientId);
      if (ingredientIndex != -1) {
        final ingredient = cartItem.ingredients[ingredientIndex];

        // Increment ingredient quantity
        ingredient.quantity?.value++;
        print(
            'Incremented ${ingredient.name} to ${ingredient.quantity?.value}');
      } else {
        print('Ingredient with id $ingredientId not found.');
      }
    } else {
      print('Cart item with id $itemId not found.');
    }
  }

  void decrementIngredientQuantity(int itemId, int ingredientId) {
    // Find the cart item
    print('calling method');
    final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final cartItem = cartItems[itemIndex];

      // Find the ingredient
      final ingredientIndex =
          cartItem.ingredients.indexWhere((ing) => ing.id == ingredientId);
      if (ingredientIndex != -1) {
        final ingredient = cartItem.ingredients[ingredientIndex];

        // Decrement ingredient quantity
        if (ingredient.quantity?.value != null &&
            ingredient.quantity!.value > 0) {
          ingredient.quantity?.value--;
          print(
              'Decremented ${ingredient.name} to ${ingredient.quantity?.value}');
        } else {
          print('Ingredient quantity is already zero-one or null.');
        }
      } else {
        print('Ingredient with id $ingredientId not found.');
      }
    } else {
      print('Cart item with id $itemId not found.');
    }
  }

  removeIngredient(int itemId, int ingredientId) {
    // Find the cart item
    final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final cartItem = cartItems[itemIndex];

      // Remove the ingredient
      cartItem.ingredients.removeWhere((ing) => ing.id == ingredientId);
      print('Removed ingredient with id $ingredientId from item $itemId');
    } else {
      print('Cart item with id $itemId not found.');
    }
  }

  void toggleItemSelection(int itemId, int ingredientId) {
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final ingredientIndex = cartItems[index]
          .ingredients
          .indexWhere((ing) => ing.id == ingredientId);
      if (ingredientIndex != -1) {
        cartItems[index].ingredients[ingredientIndex].isSelected.value =
            !cartItems[index].ingredients[ingredientIndex].isSelected.value;
        print(
            'Toggled selection for ingredient: ${cartItems[index].ingredients[ingredientIndex].name}, Selected: ${cartItems[index].ingredients[ingredientIndex].isSelected.value}');
      } else {
        print('Ingredient with id $ingredientId not found in item $itemId.');
      }

      // cartItems[index].isSelected.value = !cartItems[index].isSelected.value;
      //  print('Toggled selection for item: ${cartItems[index].name}, Selected: ${cartItems[index].isSelected.value}');
    } else {
      print('Item with id $itemId not found.');
    }
  }

  void toggleItemSelectionIngredient(int itemId) {
    int index = ingredientList.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      ingredientList[index].isSelected!.value =
          !ingredientList[index].isSelected!.value;
    } else {
      print('Ingredient with id $itemId not found in item $itemId.');
    }

    // cartItems[index].isSelected.value = !cartItems[index].isSelected.value;
    //  print('Toggled selection for item: ${cartItems[index].name}, Selected: ${cartItems[index].isSelected.value}');
  }

//   void updateCartItemPrice(int itemId, double newPrice) {
//   final index = cartItems.indexWhere((item) => item.id == itemId);
//   if (index != -1) {
//     cartItems[index]. = newPrice;
//     cartItems.refresh(); // If using RxList
//   }
// }

  void updateCustomPrice(int id, int id2, String p0) {
    int index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final ingredientIndex =
          cartItems[index].ingredients.indexWhere((ing) => ing.id == id2);
      if (ingredientIndex != -1) {
        double? parsedPrice = double.tryParse(p0);
        if (parsedPrice == null) return;
        if (cartItems[index].ingredients[ingredientIndex].basePrice != null &&
            parsedPrice <
                cartItems[index].ingredients[ingredientIndex].basePrice!)
          return;
        cartItems[index].ingredients[ingredientIndex].price = parsedPrice;
        recalculateTotals();
        cartItems.refresh(); // ← add this
        ingredientList.refresh(); // ← add this
        totalItems();
        totalIngredientPrice();
        totalIngredientPriceForIngredient();
        calculatedServiceCharge;
        //  totalPrice();
        update();
        print(
            'Updated custom price for ingredient: ${cartItems[index].ingredients[ingredientIndex].name}, New Price: ${cartItems[index].ingredients[ingredientIndex].price}');
      } else {
        print('Ingredient with id $id2 not found in item $id.');
      }
    }
  }

  void updateCustomPriceIngredient(int id, String p0) {
    print(id);
    print(p0);
    int ingredientIndex = ingredientList.indexWhere((item) => item.id == id);
    if (ingredientIndex != -1) {
      double? parsedPrice = double.tryParse(p0);

      if (parsedPrice == null) return;
      if (ingredientList[ingredientIndex].price != null &&
          parsedPrice < ingredientList[ingredientIndex].basePrice!) return;
      ingredientList[ingredientIndex].price = parsedPrice;
      recalculateTotals();
      totalItems();
      totalIngredientPrice();
      totalIngredientPriceForIngredient();
      calculatedServiceCharge;
      update();
      refresh();
    }
  }

  Future<dynamic> getCheckoutAddress() async {
    // Implement the logic to retrieve the checkout address
    isLoading.value = true;
    try {
      final response = await _apiService.getCheckoutAddress();
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        var data = jsonDecode(response.body);
        var datax = data['data'];
        myLog.log('Checkout address data: $data');
        myLog.log('Checkout address data: ${data['data']}');
        if (datax.isEmpty)
          return {};
        else
          // var data1 = data;
          // Parse the response and update the address
          // For example:
          // checkoutAddress.value = CheckoutAddress.fromJson(value.data);
          // Get.toNamed(AppRoutes.checkoutScreen, arguments: data);

          return data;
      } else {
        isLoading.value = false;
        Get.snackbar(
            'Error', 'Failed to load checkout address: ${response.body}',
            backgroundColor: Colors.red, colorText: Colors.white);
        return [];
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $error',
          backgroundColor: Colors.red, colorText: Colors.white);
      myLog.log('Error fetching checkout address: $error');
    }
    ;
    return [];
  }
}
