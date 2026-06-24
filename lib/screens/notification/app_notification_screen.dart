import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:timeago/timeago.dart' as timeago;

// ─── Model ───────────────────────────────────────────────────────────────────

class AppNotification {
  final int id;
  final String title;
  final String body;
  final String? type;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AppNotification(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: data['title']?.toString() ?? json['title']?.toString() ?? 'Notification',
      body: data['message']?.toString() ??
          data['body']?.toString() ??
          json['body']?.toString() ??
          '',
      type: data['type']?.toString() ?? json['type']?.toString(),
      isRead: json['read_at'] != null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

// ─── Controller ──────────────────────────────────────────────────────────────

class NotificationsController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 30));

  RxList<AppNotification> notifications = <AppNotification>[].obs;
  RxBool isLoading = false.obs;
  RxInt unreadCount = 0.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _api.fetchNotifications();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = body['data'] as List? ?? body as List? ?? [];
        notifications.value =
            list.map((e) => AppNotification.fromJson(e)).toList();
        unreadCount.value =
            notifications.where((n) => !n.isRead).length;
      } else {
        error.value = 'Failed to load notifications.';
      }
    } catch (e) {
      error.value = 'Network error. Pull down to retry.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final res = await _api.fetchUnreadCount();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        unreadCount.value = body['data']?['count'] ?? body['count'] ?? 0;
      }
    } catch (_) {}
  }

  Future<void> markRead(int id) async {
    try {
      await _api.markNotificationRead(id);
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        final old = notifications[idx];
        notifications[idx] = AppNotification(
          id: old.id,
          title: old.title,
          body: old.body,
          type: old.type,
          isRead: true,
          createdAt: old.createdAt,
        );
        if (unreadCount.value > 0) unreadCount.value--;
        notifications.refresh();
      }
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    for (final n in notifications.where((n) => !n.isRead).toList()) {
      await markRead(n.id);
    }
  }

  IconData _iconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
      case 'delivery':
        return Icons.delivery_dining_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return const Color(0xFF3B82F6);
      case 'payment':
        return const Color(0xFF22C55E);
      case 'promotion':
        return const Color(0xFFFFAA00);
      case 'delivery':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          Obx(() => ctrl.notifications.any((n) => !n.isRead)
              ? TextButton(
                  onPressed: ctrl.markAllRead,
                  child: const Text('Mark all read',
                      style:
                          TextStyle(color: Color(0xFFFFAA00), fontSize: 13)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFAA00)));
        }
        if (ctrl.error.value.isNotEmpty) {
          return _ErrorState(
              message: ctrl.error.value, onRetry: ctrl.fetchAll);
        }
        if (ctrl.notifications.isEmpty) {
          return const _EmptyState();
        }
        return RefreshIndicator(
          color: const Color(0xFFFFAA00),
          onRefresh: ctrl.fetchAll,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final n = ctrl.notifications[i];
              return _NotificationCard(
                notification: n,
                iconData: ctrl._iconForType(n.type),
                iconColor: ctrl._colorForType(n.type),
                onTap: () {
                  if (!n.isRead) ctrl.markRead(n.id);
                  _showDetail(context, n);
                },
              );
            },
          ),
        );
      }),
    );
  }

  void _showDetail(BuildContext context, AppNotification n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n.title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(timeago.format(n.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 16),
            Text(n.body, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? Colors.white : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isUnread
                  ? const Color(0xFFFFAA00).withOpacity(0.3)
                  : Colors.transparent),
          boxShadow: isUnread
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFAA00),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeago.format(notification.createdAt),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No notifications yet',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text("We'll notify you when something happens",
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAA00),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Badge Widget (use in AppBar or BottomNav) ───────────────────────────────

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;

  const NotificationBadge({Key? key, required this.child, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == 0) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}