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
    );
  }

  String get displayName {
    final name = ingredientId != null
        ? (ingredientName ?? productName ?? 'Item')
        : (productName ?? ingredientName ?? 'Item');
    return quantity > 1 ? '$name ×$quantity' : name;
  }
}

int _int(dynamic v) {
  if (v is int) return v;
  return int.tryParse(v?.toString() ?? '0') ?? 0;
}
