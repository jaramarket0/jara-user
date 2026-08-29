import 'dart:convert';
import 'dart:developer' as log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart' as grains;
import 'package:jara_market/screens/orders_screen/models/order_model.dart';
import 'package:jara_market/services/api_service.dart';

class OrdersController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 300));

  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;
  // Id of the order currently being rebuilt, so only that card's button
  // shows a spinner rather than every card at once.
  final RxInt reorderingId = 0.obs;
  final RxList<OrderData> allOrders = <OrderData>[].obs;
  final RxString selectedStatus = 'all'.obs;
  final RxString errorMessage = ''.obs;

  static const List<Map<String, String>> statusTabs = [
    {'key': 'all', 'label': 'All'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'processing', 'label': 'Shopping'},
    {'key': 'completed', 'label': 'Completed'},
    {'key': 'cancelled', 'label': 'Cancelled'},
  ];

  List<OrderData> get filteredOrders {
    if (selectedStatus.value == 'all') return allOrders;
    return allOrders
        .where((o) => o.status.toLowerCase() == selectedStatus.value)
        .toList();
  }

  int countForStatus(String status) {
    if (status == 'all') return allOrders.length;
    return allOrders
        .where((o) => o.status.toLowerCase() == status)
        .length;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _api.getOrders();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsed = ordersResponseFromJson(response.body);
        allOrders.value = parsed.orders;
        log.log('Orders loaded: ${allOrders.length}', name: 'OrdersController');
      } else {
        errorMessage.value = 'Failed to load orders (${response.statusCode})';
        log.log('Error: ${response.body}', name: 'OrdersController');
      }
    } catch (e) {
      errorMessage.value = 'Could not connect. Pull down to retry.';
      log.log('Exception: $e', name: 'OrdersController');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    isCancelling.value = true;
    try {
      final response = await _api.cancelOrder(orderId.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final idx = allOrders.indexWhere((o) => o.id == orderId);
        if (idx != -1) {
          final updated = allOrders[idx];
          allOrders[idx] = OrderData(
            id: updated.id,
            reference: updated.reference,
            orderDate: updated.orderDate,
            deliveryType: updated.deliveryType,
            shippingFee: updated.shippingFee,
            serviceCharge: updated.serviceCharge,
            vat: updated.vat,
            total: updated.total,
            remarks: updated.remarks,
            mealPrep: updated.mealPrep,
            status: 'cancelled',
            addressId: updated.addressId,
            createdAt: updated.createdAt,
            items: updated.items,
          );
        }
        return true;
      }
      final body = jsonDecode(response.body);
      Get.snackbar('Error', body['message'] ?? 'Could not cancel order.',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Network error. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      isCancelling.value = false;
    }
  }

  /// Puts a past order back in the cart.
  ///
  /// The rebuild happens server-side: a food order is stored as one row per
  /// recipe ingredient scaled by how many of the dish were bought, so only
  /// the backend (which holds the recipe) can say "that was 3 Atama Soups".
  /// It also reprices at today's rates and drops anything no longer sold in
  /// the customer's area.
  ///
  /// This fills the cart and opens it -- it does NOT re-place the order.
  /// Placing an order debits the wallet immediately, so the customer gets to
  /// review the new prices and confirm for themselves.
  Future<void> reorder(OrderData order) async {
    if (reorderingId.value != 0) return; // ignore double taps
    reorderingId.value = order.id;
    try {
      final response = await _api.getReorderItems(order.id.toString());
      final body = jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        Get.snackbar('Cannot reorder',
            body['message']?.toString() ?? 'Could not rebuild this order.',
            backgroundColor: Colors.red, colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return;
      }

      final data = body['data'] as Map<String, dynamic>? ?? {};
      final cart = Get.isRegistered<CartController>()
          ? Get.find<CartController>()
          : Get.put(CartController());

      var added = 0;
      for (final raw in (data['products'] as List? ?? [])) {
        final p = raw as Map<String, dynamic>;
        cart.addToCart(CartItem(
          id: p['id'] as int,
          name: p['name']?.toString() ?? 'Item',
          description: p['description']?.toString() ?? 'N/A',
          price: double.tryParse(p['price']?.toString() ?? '0') ?? 0.0,
          originalPrice: double.tryParse(p['price']?.toString() ?? '0') ?? 0.0,
          quantity: (p['order_quantity'] as int?) ?? 1,
          ingredients: (p['ingredients'] as List? ?? []).map((e) {
            final i = e as Map<String, dynamic>;
            final price = double.tryParse(i['price']?.toString() ?? '0') ?? 0.0;
            return Ingredients(
              id: i['id'] as int,
              name: i['name']?.toString(),
              description: i['description']?.toString(),
              price: price,
              basePrice: price,
              unit: i['unit']?.toString(),
              imageUrl: i['image_url']?.toString(),
            );
          }).toList(),
        ));
        added++;
      }

      for (final raw in (data['ingredients'] as List? ?? [])) {
        final i = raw as Map<String, dynamic>;
        cart.addIngredientToCart(grains.Data.fromJson(i)
          ..quantity = RxInt((i['order_quantity'] as int?) ?? 1));
        added++;
      }

      if (added == 0) {
        Get.snackbar('Cannot reorder',
            'Nothing from this order is available right now.',
            backgroundColor: Colors.red, colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return;
      }

      // Anything the backend could not bring back is named rather than
      // silently missing from the cart.
      final dropped = (data['unavailable'] as List? ?? [])
          .map((e) => e.toString())
          .toList();
      Get.snackbar(
        dropped.isEmpty ? 'Added to cart' : 'Partly added to cart',
        dropped.isEmpty
            ? 'Your order is back in the cart. Prices are today\'s.'
            : 'No longer available here: ${dropped.join(', ')}.',
        backgroundColor: dropped.isEmpty
            ? const Color(0xFF4CAF50)
            : const Color(0xFFFFAA00),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: dropped.isEmpty ? 2 : 4),
      );

      Get.toNamed(AppRoutes.cartScreen);
    } catch (e) {
      log.log('Reorder failed: $e', name: 'OrdersController');
      Get.snackbar('Error', 'Network error. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } finally {
      reorderingId.value = 0;
    }
  }

  void selectStatus(String status) {
    selectedStatus.value = status;
  }
}
