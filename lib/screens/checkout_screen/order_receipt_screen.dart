import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class OrderReceipt {
  final String orderId;
  final String orderDate;
  final List<ReceiptItem> items;
  final List<ReceiptItem> ingredients;
  final double subTotal;
  final double serviceCharge;
  final double shippingFee;
  final double vat;
  final double total;
  final String deliveryAddress;
  final String paymentMethod;
  final String status;

  OrderReceipt({
    required this.orderId,
    required this.orderDate,
    required this.items,
    this.ingredients = const [],
    required this.subTotal,
    required this.serviceCharge,
    required this.shippingFee,
    required this.vat,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = 'Confirmed',
  });

  factory OrderReceipt.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final orderItems = (data['items'] as List? ?? [])
        .map((e) => ReceiptItem.fromJson(e))
        .toList();
    final ingredientItems = (data['ingredients'] as List? ?? [])
        .map((e) => ReceiptItem.fromJson(e))
        .toList();
    return OrderReceipt(
      orderId: data['id']?.toString() ?? data['order_id']?.toString() ?? '-',
      orderDate: data['order_date']?.toString() ??
          data['created_at']?.toString() ??
          DateTime.now().toIso8601String(),
      items: orderItems,
      ingredients: ingredientItems,
      subTotal: double.tryParse(data['sub_total']?.toString() ?? '0') ?? 0.0,
      serviceCharge:
          double.tryParse(data['service_charge']?.toString() ?? '0') ?? 0.0,
      shippingFee:
          double.tryParse(data['shipping_fee']?.toString() ?? '0') ?? 0.0,
      vat: double.tryParse(data['vat']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(data['total']?.toString() ?? '0') ?? 0.0,
      deliveryAddress:
          data['address']?['contact_address']?.toString() ?? 'Pickup',
      paymentMethod: data['payment_method']?.toString() ?? 'Wallet',
      status: data['status']?.toString() ?? 'Confirmed',
    );
  }
}

class ReceiptItem {
  final String name;
  final int quantity;
  final double price;
  final String? unit;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.unit,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? json['ingredient'] ?? json;
    return ReceiptItem(
      name: product['name']?.toString() ?? json['name']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      unit: json['unit']?.toString(),
    );
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class OrderReceiptScreen extends StatefulWidget {
  final OrderReceipt? receipt;
  final Map<String, dynamic>? rawData; // pass raw API response

  const OrderReceiptScreen({Key? key, this.receipt, this.rawData})
      : super(key: key);

  @override
  State<OrderReceiptScreen> createState() => _OrderReceiptScreenState();
}

class _OrderReceiptScreenState extends State<OrderReceiptScreen> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isDownloading = false;

  late OrderReceipt receipt;

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      receipt = widget.receipt!;
    } else if (widget.rawData != null) {
      receipt = OrderReceipt.fromJson(widget.rawData!);
    } else {
      // Demo receipt for preview
      receipt = OrderReceipt(
        orderId: 'ORD-00142',
        orderDate: DateTime.now().toString(),
        items: [
          ReceiptItem(name: 'Egusi Soup', quantity: 1, price: 4500),
          ReceiptItem(name: 'Eba (Medium)', quantity: 2, price: 800),
        ],
        ingredients: [
          ReceiptItem(name: 'Tomatoes', quantity: 2, price: 500, unit: 'kg'),
        ],
        subTotal: 6600,
        serviceCharge: 1000,
        shippingFee: 2000,
        vat: 100,
        total: 9700,
        deliveryAddress: '12 Allen Avenue, Ikeja, Lagos',
        paymentMethod: 'Wallet',
        status: 'Confirmed',
      );
    }
  }

  String _formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      return '${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  Future<void> _downloadReceipt() async {
    setState(() => _isDownloading = true);
    try {
      final boundary = _receiptKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/receipt_${receipt.orderId}_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'JaraMarket Order Receipt - ${receipt.orderId}',
        subject: 'Order Receipt',
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not save receipt: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Order Receipt',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17)),
        actions: [
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFFFFAA00)))
                : const Icon(Icons.download_rounded, color: Color(0xFFFFAA00)),
            onPressed: _isDownloading ? null : _downloadReceipt,
            tooltip: 'Download / Share Receipt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Receipt Card (captured for download) ──
            RepaintBoundary(
              key: _receiptKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFFFAA00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Order Confirmed!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Order #${receipt.orderId}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(_formatDate(receipt.orderDate),
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),

                    // Status pill
                    Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          receipt.status,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Items ──
                          if (receipt.items.isNotEmpty) ...[
                            const _ReceiptSectionHeader('Products'),
                            ...receipt.items.map((item) =>
                                _ReceiptItemRow(item: item, formatCurrency: _formatCurrency)),
                          ],
                          if (receipt.ingredients.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const _ReceiptSectionHeader('Ingredients'),
                            ...receipt.ingredients.map((item) =>
                                _ReceiptItemRow(item: item, formatCurrency: _formatCurrency)),
                          ],

                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          const SizedBox(height: 16),

                          // ── Totals ──
                          _TotalRow(
                              label: 'Subtotal',
                              value: _formatCurrency(receipt.subTotal)),
                          _TotalRow(
                              label: 'Service Charge',
                              value: _formatCurrency(receipt.serviceCharge)),
                          _TotalRow(
                              label: 'Shipping',
                              value: _formatCurrency(receipt.shippingFee)),
                          _TotalRow(
                              label: 'VAT',
                              value: _formatCurrency(receipt.vat)),
                          const Divider(height: 16, color: Color(0xFFF3F4F6)),
                          _TotalRow(
                            label: 'TOTAL',
                            value: _formatCurrency(receipt.total),
                            isBold: true,
                            color: const Color(0xFFFFAA00),
                          ),

                          const SizedBox(height: 20),
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          const SizedBox(height: 16),

                          // ── Delivery info ──
                          _InfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Delivery To',
                              value: receipt.deliveryAddress),
                          const SizedBox(height: 10),
                          _InfoRow(
                              icon: Icons.payment_rounded,
                              label: 'Payment Method',
                              value: receipt.paymentMethod),

                          const SizedBox(height: 24),
                          // ── Footer ──
                          Center(
                            child: Column(
                              children: [
                                const Text('Thank you for shopping with us!',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFFAA00))),
                                const SizedBox(height: 4),
                                Text('JaraMarket — Fresh from the market',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade400)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isDownloading ? null : _downloadReceipt,
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Color(0xFFFFAA00)))
                        : const Icon(Icons.download_rounded,
                            color: Color(0xFFFFAA00), size: 18),
                    label: const Text('Download',
                        style: TextStyle(color: Color(0xFFFFAA00))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFAA00)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.offAllNamed('/main_screen'),
                    icon: const Icon(Icons.home_rounded,
                        color: Colors.white, size: 18),
                    label: const Text('Back to Home',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAA00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Shared receipt sub-widgets ───────────────────────────────────────────────

class _ReceiptSectionHeader extends StatelessWidget {
  final String title;
  const _ReceiptSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151))),
    );
  }
}

class _ReceiptItemRow extends StatelessWidget {
  final ReceiptItem item;
  final String Function(double) formatCurrency;

  const _ReceiptItemRow(
      {required this.item, required this.formatCurrency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('${item.quantity}x',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.unit != null
                  ? '${item.name} (${item.unit})'
                  : item.name,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(formatCurrency(item.price * item.quantity),
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isBold ? 15 : 13,
                  fontWeight:
                      isBold ? FontWeight.w700 : FontWeight.w400,
                  color: isBold ? Colors.black : Colors.grey.shade600)),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16 : 13,
                  fontWeight:
                      isBold ? FontWeight.w800 : FontWeight.w600,
                  color: color ?? Colors.black)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFFFFAA00)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade400)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}