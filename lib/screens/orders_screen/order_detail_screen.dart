import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jara_market/screens/orders_screen/models/order_model.dart';
import 'package:jara_market/services/api_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderData order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderData _order;
  static const Color _primary = Color(0xFFFFAA00);

  final ApiService _api = ApiService(const Duration(seconds: 60));
  Timer? _poller;
  bool _refreshing = false;
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _startPolling();
  }

  @override
  void dispose() {
    _poller?.cancel();
    super.dispose();
  }

  /// Items are accepted and delivered by different vendors at their own
  /// pace, so an open order changes underneath the customer. Poll while it's
  /// still in flight and stop once it's completed/cancelled.
  void _startPolling() {
    _poller?.cancel();
    if (!_isActive) return;
    _poller = Timer.periodic(const Duration(seconds: 20), (_) => _refresh(silent: true));
  }

  bool get _isActive =>
      _order.progress?.isActive ??
      !['completed', 'cancelled'].contains(_order.status.toLowerCase());

  Future<void> _refresh({bool silent = false}) async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      final res = await _api.getOrder(_order.id.toString());
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        final data = body is Map ? body['data'] : null;
        if (data is Map<String, dynamic> && mounted) {
          setState(() => _order = OrderData.fromJson(data));
          if (!_isActive) _poller?.cancel();
        }
      }
    } catch (_) {
      // Keep showing the last known state; the next tick will retry.
    } finally {
      _refreshing = false;
      if (!silent && mounted) setState(() {});
    }
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
    const names = {
      'placed': 'Order Placed',
      'shopping': 'Shopping',
      'vendor_delivered': 'Vendor Delivered',
      'admin_approved': 'Admin Approved',
      'logistics': 'Out for Delivery',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };
    final stage = _order.progress?.stage;
    if (stage != null && names.containsKey(stage)) return names[stage]!;
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
              child: RefreshIndicator(
                color: _primary,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(),
                    if (_order.progress?.canMarkReceived == true) ...[
                      const SizedBox(height: 12),
                      _buildReceiveButton(),
                    ],
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
                  ],
                ),
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
            _buildTracker(),
          ],
        ],
      ),
    );
  }

  String _statusSubtitle() {
    final p = _order.progress;
    if (_order.status.toLowerCase() == 'cancelled') {
      return 'This order was cancelled.';
    }
    final remaining = p?.remainingItems ?? 0;
    final total = p?.totalItems ?? _order.items.length;
    switch (p?.stage ?? '') {
      case 'placed':
        return 'Finding vendors for your items.';
      case 'shopping':
        final done = total - remaining;
        return 'Vendors are shopping — $done of $total item(s) delivered.';
      case 'vendor_delivered':
        return 'All items delivered by vendors. Awaiting admin approval.';
      case 'admin_approved':
        return 'Approved. Preparing your delivery.';
      case 'logistics':
        return 'Your order is on its way.';
      case 'delivered':
        return 'Your order has been delivered. Enjoy!';
    }
    // Fallback for responses without a progress block.
    switch (_order.status.toLowerCase()) {
      case 'pending':
        return 'Your order is waiting to be confirmed.';
      case 'processing':
      case 'accepted':
        return 'Your order is being prepared.';
      case 'completed':
      case 'delivered':
        return 'Your order has been delivered. Enjoy!';
      default:
        return 'Order placed on ${_formatDate(_order.orderDate ?? _order.createdAt)}';
    }
  }

  /// Stage list mirrors the backend's `progress.stages`, so both agree on
  /// what the order is doing: placed -> shopping -> vendor delivered ->
  /// admin approved -> logistics -> delivered.
  static const List<Map<String, dynamic>> _stageMeta = [
    {'key': 'placed', 'label': 'Placed', 'icon': Icons.receipt_long_outlined},
    {'key': 'shopping', 'label': 'Shopping', 'icon': Icons.shopping_basket_outlined},
    {'key': 'vendor_delivered', 'label': 'Vendor\nDelivered', 'icon': Icons.storefront_outlined},
    {'key': 'admin_approved', 'label': 'Admin\nApproved', 'icon': Icons.verified_outlined},
    {'key': 'logistics', 'label': 'Logistics', 'icon': Icons.local_shipping_outlined},
    {'key': 'delivered', 'label': 'Delivered', 'icon': Icons.check_circle_outline_rounded},
  ];

  /// How far along we are. Falls back to the order status when the backend
  /// hasn't sent a progress block (older API responses).
  int get _currentStageIndex {
    final p = _order.progress;
    if (p != null) return p.stageIndex;
    switch (_order.status.toLowerCase()) {
      case 'processing':
      case 'accepted':
        return 1;
      case 'delivered':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildTracker() {
    final current = _currentStageIndex;
    final remaining = _order.progress?.remainingItems ?? 0;

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_stageMeta.length * 2 - 1, (i) {
          // Odd slots are the connecting lines between two steps.
          if (i.isOdd) {
            final done = (i ~/ 2) < current;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: 2,
                color: done ? _primary : const Color(0xFFE0E0E0),
              ),
            );
          }

          final idx = i ~/ 2;
          final meta = _stageMeta[idx];
          final isDone = idx < current;
          final isCurrent = idx == current;
          final reached = isDone || isCurrent;
          // The badge counts items still being sourced, and only makes
          // sense while shopping is the live stage.
          final showBadge =
              meta['key'] == 'shopping' && isCurrent && remaining > 0;

          return SizedBox(
            width: 52,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: reached ? _primary : const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: _primary.withOpacity(0.35),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        isDone
                            ? Icons.check_rounded
                            : meta['icon'] as IconData,
                        size: 17,
                        color: reached ? Colors.white : const Color(0xFFBDBDBD),
                      ),
                    ),
                    if (showBadge)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          constraints: const BoxConstraints(minWidth: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF44336),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            '$remaining',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  meta['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    height: 1.2,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: reached
                        ? const Color(0xFF212429)
                        : const Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  Future<void> _markReceived() async {
    if (_confirming) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm delivery'),
        content: const Text(
            'Only confirm once you have actually received this order. '
            'This closes the order and cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not yet'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, I received it'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _confirming = true);
    try {
      final res = await _api.markOrderReceived(_order.id.toString());
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body is Map ? body['data'] : null;
        if (data is Map<String, dynamic> && mounted) {
          setState(() => _order = OrderData.fromJson(data));
          _poller?.cancel();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Thanks — order confirmed as received.'),
            backgroundColor: Color(0xFF4CAF50),
          ));
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(body is Map
              ? (body['message']?.toString() ?? 'Could not confirm delivery.')
              : 'Could not confirm delivery.'),
          backgroundColor: const Color(0xFFF44336),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Network error — please try again.'),
          backgroundColor: Color(0xFFF44336),
        ));
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Widget _buildReceiveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _confirming ? null : _markReceived,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          disabledBackgroundColor: const Color(0xFFE0E0E0),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        icon: _confirming
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.inventory_2_outlined,
                size: 18, color: Colors.white),
        label: Text(
          _confirming ? 'Confirming…' : 'I have received this order',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  /// Let the customer swap an item no market could supply. Options come from
  /// the backend already filtered to what a vendor near them can serve.
  Future<void> _openReplaceSheet(OrderItem item) async {
    List<dynamic> options = [];
    bool loading = true;
    String? loadError;

    Future<void> load(StateSetter refresh) async {
      try {
        final res = await _api.getItemReplacements(item.id);
        final body = jsonDecode(res.body);
        if (res.statusCode == 200) {
          options = (body['data']?['options'] as List?) ?? [];
          if (options.isEmpty) {
            loadError = 'No alternatives can be delivered to your area yet.';
          }
        } else {
          loadError = body['message']?.toString() ?? 'Could not load options.';
        }
      } catch (_) {
        loadError = 'Network error — please try again.';
      }
      loading = false;
      refresh(() {});
    }

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(builder: (sheetCtx, refresh) {
        if (loading) load(refresh);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.92,
          builder: (_, scrollController) => Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Replace item',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '${item.displayName} isn\'t available. Pick an alternative — '
                      'any price difference is settled with your wallet.',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF888888), height: 1.4),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20),
              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(color: _primary))
                    : loadError != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(loadError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFF888888))),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: options.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, color: Color(0xFFF5F5F5)),
                            itemBuilder: (_, i) {
                              final opt = options[i] as Map<String, dynamic>;
                              final unit = double.tryParse(
                                      opt['price']?.toString() ?? '0') ??
                                  0;
                              final newTotal = unit * item.quantity;
                              final oldTotal =
                                  double.tryParse(item.amount) ?? 0;
                              final diff = newTotal - oldTotal;
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                leading: _ItemThumb(
                                    imageUrl: opt['image_url']?.toString(),
                                    isIngredient: true),
                                title: Text(opt['name']?.toString() ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  '₦${unit.toStringAsFixed(2)} × ${item.quantity}'
                                  '  •  ${diff == 0 ? "same price" : diff > 0 ? "+₦${diff.toStringAsFixed(2)}" : "-₦${(-diff).toStringAsFixed(2)}"}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: diff > 0
                                        ? const Color(0xFFF44336)
                                        : diff < 0
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFF888888),
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right,
                                    color: Color(0xFFBDBDBD)),
                                onTap: () {
                                  Navigator.pop(sheetCtx);
                                  _confirmReplace(item, opt, diff);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _confirmReplace(
      OrderItem item, Map<String, dynamic> option, double diff) async {
    final name = option['name']?.toString() ?? 'this item';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm replacement'),
        content: Text(
          diff > 0
              ? 'Replace ${item.displayName} with $name?\n\n₦${diff.toStringAsFixed(2)} will be deducted from your wallet.'
              : diff < 0
                  ? 'Replace ${item.displayName} with $name?\n\n₦${(-diff).toStringAsFixed(2)} will be returned to your wallet.'
                  : 'Replace ${item.displayName} with $name?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      final res = await _api.replaceOrderItem(
          item.id, _int(option['id']),
          quantity: item.quantity);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data']?['order'];
        if (data is Map<String, dynamic> && mounted) {
          setState(() => _order = OrderData.fromJson(data));
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Replaced with $name.'),
            backgroundColor: const Color(0xFF4CAF50),
          ));
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(body['message']?.toString() ?? 'Replacement failed.'),
          backgroundColor: const Color(0xFFF44336),
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Network error — please try again.'),
          backgroundColor: Color(0xFFF44336),
        ));
      }
    }
  }

  static int _int(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;

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
          return _ItemRow(
            item: item,
            isLast: i == _order.items.length - 1,
            onReplace: item.isUnavailable ? () => _openReplaceSheet(item) : null,
          );
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
  final VoidCallback? onReplace;

  const _ItemRow({required this.item, this.isLast = false, this.onReplace});

  @override
  Widget build(BuildContext context) {
    final isIngredient = item.ingredientId != null;
    final name = isIngredient
        ? (item.ingredientName ?? item.productName ?? 'Item')
        : (item.productName ?? item.ingredientName ?? 'Item');
    final amount = double.tryParse(item.amount) ?? 0;
    final price = double.tryParse(item.price) ?? 0;

    final unavailable = item.isUnavailable;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: unavailable ? 8 : 0),
          padding: EdgeInsets.all(unavailable ? 10 : 0),
          decoration: unavailable
              ? BoxDecoration(
                  // Flag it clearly: this line needs the customer to act.
                  color: const Color(0xFFFFF6F6),
                  border: Border.all(color: const Color(0xFFF44336), width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Column(
            children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              _ItemThumb(imageUrl: item.imageUrl, isIngredient: isIngredient),
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
              if (unavailable) ...[
                Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 15, color: Color(0xFFF44336)),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Unavailable — no market near you can supply this.',
                        style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFFD32F2F),
                            height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onReplace,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFF44336)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9)),
                    ),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 17),
                    label: const Text('Replace this item',
                        style: TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (!isLast && !unavailable)
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

/// Real product/ingredient photo, falling back to the old category icon
/// when the item has no image or the download fails.
class _ItemThumb extends StatelessWidget {
  final String? imageUrl;
  final bool isIngredient;

  const _ItemThumb({required this.imageUrl, required this.isIngredient});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: (url == null || url.isEmpty)
            ? _fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFFBDBDBD)),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _fallback() => Container(
        color: isIngredient ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        child: Icon(
          isIngredient ? Icons.grass_outlined : Icons.fastfood_outlined,
          size: 20,
          color: isIngredient
              ? const Color(0xFF4CAF50)
              : const Color(0xFFFFAA00),
        ),
      );
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
