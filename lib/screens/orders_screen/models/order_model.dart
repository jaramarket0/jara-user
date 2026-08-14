import 'dart:convert';

OrdersResponse ordersResponseFromJson(String src) =>
    OrdersResponse.fromJson(json.decode(src));

class OrdersResponse {
  final bool status;
  final String message;
  final List<OrderData> orders;
  final int currentPage;
  final int lastPage;
  final int total;

  OrdersResponse({
    required this.status,
    required this.message,
    required this.orders,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    List<OrderData> orders = [];
    int currentPage = 1, lastPage = 1, total = 0;

    if (raw is Map<String, dynamic>) {
      final list = raw['data'];
      if (list is List) {
        orders = list
            .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      currentPage = raw['current_page'] ?? 1;
      lastPage = raw['last_page'] ?? 1;
      total = raw['total'] ?? 0;
    } else if (raw is List) {
      orders =
          raw.map((e) => OrderData.fromJson(e as Map<String, dynamic>)).toList();
      total = orders.length;
    }

    return OrdersResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      orders: orders,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }
}

class OrderData {
  final int id;
  final String reference;
  final String? orderDate;
  final String deliveryType;
  final String shippingFee;
  final String serviceCharge;
  final String vat;
  final String total;
  final String? remarks;
  final bool mealPrep;
  final String status;
  final int? addressId;
  final String createdAt;
  final List<OrderItem> items;
  final OrderProgress? progress;

  OrderData({
    required this.id,
    required this.reference,
    this.orderDate,
    required this.deliveryType,
    required this.shippingFee,
    required this.serviceCharge,
    required this.vat,
    required this.total,
    this.remarks,
    required this.mealPrep,
    required this.status,
    this.addressId,
    required this.createdAt,
    required this.items,
    this.progress,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    List<OrderItem> items = [];
    if (itemsRaw is List) {
      items = itemsRaw
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return OrderData(
      id: _int(json['id']),
      reference: json['reference']?.toString() ?? '#${json['id']}',
      orderDate: json['order_date']?.toString(),
      deliveryType: json['delivery_type']?.toString() ?? '',
      shippingFee: json['shipping_fee']?.toString() ?? '0',
      serviceCharge: json['service_charge']?.toString() ?? '0',
      vat: json['vat']?.toString() ?? '0',
      total: json['total']?.toString() ?? '0',
      remarks: json['remarks']?.toString(),
      mealPrep: json['meal_prep'] == true,
      status: json['status']?.toString() ?? 'pending',
      addressId: json['address_id'] != null ? _int(json['address_id']) : null,
      createdAt: json['created_at']?.toString() ?? '',
      items: items,
      progress: json['progress'] is Map<String, dynamic>
          ? OrderProgress.fromJson(json['progress'] as Map<String, dynamic>)
          : null,
    );
  }

  String get itemsSummary {
    if (items.isEmpty) return 'No items';
    final names = items.map((i) => i.displayName).toList();
    if (names.length <= 2) return names.join(', ');
    return '${names.take(2).join(', ')} +${names.length - 2} more';
  }

  String get formattedTotal {
    final d = double.tryParse(total) ?? 0;
    return '₦${d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }
}

class OrderItem {
  final int id;
  final int? ingredientId;
  final String? ingredientName;
  final int? productId;
  final String? productName;
  final int quantity;
  final String price;
  final String? unit;
  final String amount;
  final String status;
  final String? imageUrl;
  final bool isUnavailable;

  OrderItem({
    required this.id,
    this.ingredientId,
    this.ingredientName,
    this.productId,
    this.productName,
    required this.quantity,
    required this.price,
    this.unit,
    required this.amount,
    required this.status,
    this.imageUrl,
    this.isUnavailable = false,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: _int(json['id']),
      ingredientId:
          json['ingredient_id'] != null ? _int(json['ingredient_id']) : null,
      ingredientName: json['ingredient_name']?.toString(),
      productId: json['product_id'] != null ? _int(json['product_id']) : null,
      productName: json['product_name']?.toString(),
      quantity: _int(json['quantity']),
      price: json['price']?.toString() ?? '0',
      unit: json['unit']?.toString(),
      amount: json['amount']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'pending',
      imageUrl: (json['image_url']?.toString().isNotEmpty ?? false)
          ? json['image_url'].toString()
          : null,
      isUnavailable: json['is_unavailable'] == true ||
          json['status']?.toString() == 'unavailable',
    );
  }

  String get displayName {
    final name = ingredientId != null
        ? (ingredientName ?? productName ?? 'Item')
        : (productName ?? ingredientName ?? 'Item');
    return quantity > 1 ? '$name ×$quantity' : name;
  }
}

/// Server-resolved fulfilment progress for an order. The backend owns the
/// stage logic (items are accepted and delivered individually), so the app
/// just renders what it's told rather than inferring from raw statuses.
class OrderProgress {
  final String stage;
  final int stageIndex;
  final List<String> stages;
  final int totalItems;
  final int acceptedItems;
  final int deliveredItems;
  final int remainingItems;
  final bool isActive;
  final bool canMarkReceived;

  const OrderProgress({
    required this.stage,
    required this.stageIndex,
    required this.stages,
    required this.totalItems,
    required this.acceptedItems,
    required this.deliveredItems,
    required this.remainingItems,
    required this.isActive,
    required this.canMarkReceived,
  });

  bool get isCancelled => stage == 'cancelled';

  factory OrderProgress.fromJson(Map<String, dynamic> json) {
    return OrderProgress(
      stage: json['stage']?.toString() ?? 'placed',
      stageIndex: _int(json['stage_index']),
      stages: (json['stages'] as List?)?.map((e) => e.toString()).toList() ??
          const ['placed', 'shopping', 'vendor_delivered', 'admin_approved',
                 'logistics', 'delivered'],
      totalItems: _int(json['total_items']),
      acceptedItems: _int(json['accepted_items']),
      deliveredItems: _int(json['delivered_items']),
      remainingItems: _int(json['remaining_items']),
      isActive: json['is_active'] != false,
      canMarkReceived: json['can_mark_received'] == true,
    );
  }
}

int _int(dynamic v) {
  if (v is int) return v;
  return int.tryParse(v?.toString() ?? '0') ?? 0;
}
