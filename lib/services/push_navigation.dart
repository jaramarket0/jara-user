import 'dart:convert';
import 'dart:developer' as myLog;

import 'package:get/get.dart';

import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/orders_screen/models/order_model.dart';
import 'package:jara_market/screens/orders_screen/order_detail_screen.dart';
import 'package:jara_market/services/api_service.dart';

/// Where a tapped push should take the customer.
///
/// The backend sends `type` in the notification payload; without this, every
/// notification just opened the app on whatever screen it was last on. That
/// made "Tap to choose a replacement" untrue -- the customer had to find the
/// order themselves.
Future<void> handlePushTap(Map<String, dynamic> data) async {
  final type = data['type']?.toString() ?? '';
  final orderId = data['order_id']?.toString() ?? '';
  myLog.log('Push tapped: type=$type order_id=$orderId');

  switch (type) {
    case 'order_item_unavailable':
    case 'order_status':
    case 'order_item_status':
      await _openOrder(orderId);
      break;
    default:
      break; // nothing specific to open
  }
}

Future<void> _openOrder(String orderId) async {
  if (orderId.isEmpty) return;
  // The push can arrive before the user has signed in on this device.
  // Resolved through Get rather than the global in main_screen.dart so a
  // service doesn't have to import a screen.
  if (!Get.isRegistered<DataBase>()) return;
  final token = await Get.find<DataBase>().getToken();
  if (token.isEmpty) return;

  try {
    final api = ApiService(const Duration(seconds: 60));
    final response = await api.getOrder(orderId);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final payload = body['data'];
      if (payload is Map<String, dynamic>) {
        Get.to(() => OrderDetailScreen(order: OrderData.fromJson(payload)));
        return;
      }
    }
    myLog.log('Push tap: could not load order $orderId (${response.statusCode})');
  } catch (e) {
    myLog.log('Push tap: failed to open order $orderId — $e');
  }
  // Couldn't resolve the specific order — the orders list is still closer to
  // where they need to be than wherever the app happened to be.
  Get.toNamed(AppRoutes.ordersScreen);
}
