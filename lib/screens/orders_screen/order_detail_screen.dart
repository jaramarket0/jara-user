import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/orders_screen/controller/orders_controller.dart';
import 'package:jara_market/screens/orders_screen/models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderData order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderData _order;
  static const Color _primary = Color(0xFFFFAA00);

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Color get _statusColor {
    switch (_order.status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'processing':
      case 'accepted':
        return const Color(0xFF2196F3);
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'pending':
      default:
        return _primary;
    }
  }

  String get _statusLabel {
    final s = _order.status;
    if (s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month]} ${dt.day}, ${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw.length > 16 ? raw.substring(0, 16) : raw;
    }
  }

  String _fmt(String v) {
    final d = double.tryParse(v) ?? 0;
    return '₦${d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    _buildOrderInfo(),
                    const SizedBox(height: 16),
                    _buildItemsList(),
                    const SizedBox(height: 16),
                    _buildPriceBreakdown(),
                    if (_order.remarks?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      _buildRemarks(),
                    ],
                    const SizedBox(height: 24),
                    if (_order.status.toLowerCase() == 'pending')
                      _buildCancelButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Order #${_order.reference}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212429),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final steps = _buildProgressSteps();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: _statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _statusSubtitle(),
            style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
          if (_order.status.toLowerCase() != 'cancelled') ...[
            const SizedBox(height: 20),
            _buildTracker(steps),
          ],
        ],
      ),
    );
  }

  String _statusSubtitle() {
    switch (_order.status.toLowerCase()) {
      case 'pending':
        return 'Your order is waiting to be confirmed.';
      case 'processing':
      case 'accepted':
        return 'Your order is being prepared.';
      case 'completed':
      case 'delivered':
        return 'Your order has been delivered. Enjoy!';
      case 'cancelled':
        return 'This order was cancelled.';
      default:
        return 'Order placed on ${_formatDate(_order.orderDate ?? _order.createdAt)}';
    }
  }

  List<Map<String, dynamic>> _buildProgressSteps() {
    final statusOrder = ['pending', 'processing', 'completed'];
    final current = _order.status.toLowerCase();
    final currentIdx = statusOrder.indexOf(current);

    return [
      {
        'icon': Icons.receipt_outlined,
        'label': 'Order Placed',
        'done': currentIdx >= 0,
      },
      {
        'icon': Icons.kitchen_outlined,
        'label': 'Preparing',
        'done': currentIdx >= 1,
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'label': 'Completed',
        'done': currentIdx >= 2,
      },
    ];
  }

  Widget _buildTracker(List<Map<String, dynamic>> steps) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftDone = steps[i ~/ 2]['done'] as bool;
          final rightDone = steps[i ~/ 2 + 1]['done'] as bool;
          return Expanded(
            child: Container(
              height: 2,
              color: leftDone && rightDone
                  ? _primary
                  : const Color(0xFFE0E0E0),
            ),
          );
        }
        final step = steps[i ~/ 2];
        final done = step['done'] as bool;
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: done ? _primary : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                step['icon'] as IconData,
                size: 18,
                color: done ? Colors.white : const Color(0xFFBBBBBB),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              step['label'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: done ? const Color(0xFF212429) : const Color(0xFFBBBBBB),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderInfo() {
    return _Card(
      title: 'Order Info',
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: _formatDate(_order.orderDate ?? _order.createdAt),
          ),
          _InfoRow(
            icon: _order.deliveryType.toLowerCase().contains('pickup')
                ? Icons.store_outlined
                : Icons.delivery_dining_outlined,
            label: 'Delivery Type',
            value: _order.deliveryType.isEmpty
                ? 'Standard'
                : _order.deliveryType[0].toUpperCase() +
                    _order.deliveryType.substring(1),
          ),
          _InfoRow(
            icon: Icons.tag_outlined,
            label: 'Reference',
            value: _order.reference,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return _Card(
      title: 'Items (${_order.items.length})',
      child: Column(
        children: List.generate(_order.items.length, (i) {
          final item = _order.items[i];
          return _ItemRow(item: item, isLast: i == _order.items.length - 1);
        }),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = _order.items.fold<double>(
        0, (s, i) => s + (double.tryParse(i.amount) ?? 0));
    final shipping = double.tryParse(_order.shippingFee) ?? 0;
    final service = double.tryParse(_order.serviceCharge) ?? 0;
    final vat = double.tryParse(_order.vat) ?? 0;

    return _Card(
      title: 'Price Breakdown',
      child: Column(
        children: [
          _PriceRow(label: 'Subtotal', value: _fmt(subtotal.toString())),
          _PriceRow(label: 'Shipping Fee', value: _fmt(shipping.toString())),
          if (service > 0)
            _PriceRow(label: 'Service Charge', value: _fmt(service.toString())),
          if (vat > 0)
            _PriceRow(label: 'VAT', value: _fmt(vat.toString())),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          _PriceRow(
            label: 'Total',
            value: _order.formattedTotal,
            isBold: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRemarks() {
    return _Card(
      title: 'Special Instructions',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          _order.remarks ?? '',
          style: const TextStyle(
              fontSize: 14, color: Color(0xFF555555), height: 1.5),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Obx(() {
      final ctrl = Get.find<OrdersController>();
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: ctrl.isCancelling.value
              ? null
              : () async {
                  final confirmed = await _showCancelDialog();
                  if (confirmed == true) {
                    final ok = await ctrl.cancelOrder(_order.id);
                    if (ok && mounted) {
                      setState(() {
                        _order = OrderData(
                          id: _order.id,
                          reference: _order.reference,
                          orderDate: _order.orderDate,
                          deliveryType: _order.deliveryType,
                          shippingFee: _order.shippingFee,
                          serviceCharge: _order.serviceCharge,
                          vat: _order.vat,
                          total: _order.total,
                          remarks: _order.remarks,
                          mealPrep: _order.mealPrep,
                          status: 'cancelled',
                          addressId: _order.addressId,
                          createdAt: _order.createdAt,
                          items: _order.items,
                        );
                      });
                      Get.snackbar('Cancelled',
                          'Order #${_order.reference} has been cancelled.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP);
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            disabledBackgroundColor: Colors.red.withOpacity(0.5),
            minimumSize: const Size(double.infinity, 52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: ctrl.isCancelling.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Cancel Order',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
        ),
      );
    });
  }

  Future<bool?> _showCancelDialog() {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'This action cannot be undone. Your wallet will be refunded within 24 hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it',
                style: TextStyle(color: Color(0xFF666666))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212429))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF888888)),
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF888888))),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212429)),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;
  final bool isLast;

  const _ItemRow({required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final isIngredient = item.ingredientId != null;
    final name = isIngredient
        ? (item.ingredientName ?? item.productName ?? 'Item')
        : (item.productName ?? item.ingredientName ?? 'Item');
    final amount = double.tryParse(item.amount) ?? 0;
    final price = double.tryParse(item.price) ?? 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isIngredient
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isIngredient
                      ? Icons.grass_outlined
                      : Icons.fastfood_outlined,
                  size: 20,
                  color: isIngredient
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFFFAA00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212429))),
                    Text(
                      '₦${price.toStringAsFixed(2)} × ${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
              Text(
                '₦${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212429)),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isLast;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isLast = false,
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
                  color: isBold
                      ? const Color(0xFF212429)
                      : const Color(0xFF666666))),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16 : 13,
                  fontWeight:
                      isBold ? FontWeight.w800 : FontWeight.w600,
                  color: isBold
                      ? const Color(0xFF212429)
                      : const Color(0xFF444444))),
        ],
      ),
    );
  }
}
