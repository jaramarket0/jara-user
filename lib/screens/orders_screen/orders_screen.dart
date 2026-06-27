import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:jara_market/screens/orders_screen/controller/orders_controller.dart';
import 'package:jara_market/screens/orders_screen/models/order_model.dart';
import 'package:jara_market/screens/orders_screen/order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersController _ctrl = Get.put(OrdersController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static const Color _primary = Color(0xFFFFAA00);

  void _onRefresh() async {
    await _ctrl.fetchOrders();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: const WaterDropHeader(
            waterDropColor: _primary,
            complete: Icon(Icons.check, color: _primary),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildStatusTabs(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Orders',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF212429),
            ),
          ),
          Obx(() => _ctrl.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: _primary),
                )
              : GestureDetector(
                  onTap: _ctrl.fetchOrders,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.refresh_rounded,
                        size: 18, color: Color(0xFF212429)),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Obx(() {
      return SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: OrdersController.statusTabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final tab = OrdersController.statusTabs[i];
            final key = tab['key']!;
            final label = tab['label']!;
            final isSelected = _ctrl.selectedStatus.value == key;
            final count = _ctrl.countForStatus(key);

            return GestureDetector(
              onTap: () => _ctrl.selectStatus(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _primary : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? Colors.white : const Color(0xFF666666),
                      ),
                    ),
                    if (count > 0 && key != 'all') ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : _statusColor(key).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : _statusColor(key),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildBody() {
    return Obx(() {
      if (_ctrl.isLoading.value && _ctrl.allOrders.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: _primary),
        );
      }

      if (_ctrl.errorMessage.value.isNotEmpty && _ctrl.allOrders.isEmpty) {
        return _buildError();
      }

      final orders = _ctrl.filteredOrders;

      if (orders.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: orders.length,
        itemBuilder: (_, i) => _OrderCard(
          order: orders[i],
          onTap: () => _openDetail(orders[i]),
          onCancel: () => _confirmCancel(orders[i]),
        ),
      );
    });
  }

  void _openDetail(OrderData order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(order: order),
      ),
    ).then((_) => _ctrl.fetchOrders());
  }

  void _confirmCancel(OrderData order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            'Are you sure you want to cancel order #${order.reference}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Order',
                style: TextStyle(color: Color(0xFF666666))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _ctrl.cancelOrder(order.id);
              if (ok && mounted) {
                Get.snackbar('Cancelled',
                    'Order #${order.reference} has been cancelled.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP);
              }
            },
            child: const Text('Cancel Order',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 48, color: _primary),
          ),
          const SizedBox(height: 20),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212429),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _ctrl.selectedStatus.value == 'all'
                ? 'When you place an order,\nit will appear here.'
                : 'No ${_ctrl.selectedStatus.value} orders found.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 32),
          if (_ctrl.selectedStatus.value != 'all')
            TextButton(
              onPressed: () => _ctrl.selectStatus('all'),
              child: const Text('View all orders',
                  style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_ctrl.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _ctrl.fetchOrders,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
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
      return const Color(0xFFFFAA00);
  }
}

String _statusLabel(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return 'Completed';
    case 'delivered':
      return 'Delivered';
    case 'processing':
      return 'Processing';
    case 'accepted':
      return 'Accepted';
    case 'cancelled':
      return 'Cancelled';
    case 'pending':
      return 'Pending';
    default:
      return status[0].toUpperCase() + status.substring(1);
  }
}

String _formatDate(String raw) {
  if (raw.isEmpty) return '';
  try {
    final dt = DateTime.parse(raw);
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  } catch (_) {
    return raw.length > 10 ? raw.substring(0, 10) : raw;
  }
}

class _OrderCard extends StatelessWidget {
  final OrderData order;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
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
            // Top row: status bar accent
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.reference}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF212429),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(
                                  order.orderDate ?? order.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),
                  // Items summary
                  Row(
                    children: [
                      const Icon(Icons.fastfood_outlined,
                          size: 16, color: Color(0xFF888888)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.itemsSummary,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF444444),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Delivery type
                  Row(
                    children: [
                      Icon(
                        order.deliveryType.toLowerCase().contains('pickup')
                            ? Icons.store_outlined
                            : Icons.delivery_dining_outlined,
                        size: 16,
                        color: const Color(0xFF888888),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.deliveryType.isEmpty
                            ? 'Standard Delivery'
                            : _capitalize(order.deliveryType),
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Footer: total + actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF888888)),
                          ),
                          Text(
                            order.formattedTotal,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF212429),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (order.status.toLowerCase() == 'pending')
                            _ActionButton(
                              label: 'Cancel',
                              color: Colors.red,
                              outline: true,
                              onTap: onCancel,
                            ),
                          if (order.status.toLowerCase() == 'pending')
                            const SizedBox(width: 8),
                          _ActionButton(
                            label: 'Details',
                            color: const Color(0xFFFFAA00),
                            outline: false,
                            onTap: onTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            _statusLabel(status),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool outline;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.outline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: outline ? color : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: outline ? color : Colors.white,
          ),
        ),
      ),
    );
  }
}
