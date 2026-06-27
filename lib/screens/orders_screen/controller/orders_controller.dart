import 'dart:convert';
import 'dart:developer' as log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/orders_screen/models/order_model.dart';
import 'package:jara_market/services/api_service.dart';

class OrdersController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 300));

  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;
  final RxList<OrderData> allOrders = <OrderData>[].obs;
  final RxString selectedStatus = 'all'.obs;
  final RxString errorMessage = ''.obs;

  static const List<Map<String, String>> statusTabs = [
    {'key': 'all', 'label': 'All'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'processing', 'label': 'Processing'},
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

  void selectStatus(String status) {
    selectedStatus.value = status;
  }
}
