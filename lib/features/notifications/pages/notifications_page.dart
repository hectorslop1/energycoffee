import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getMockNotifications();

    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundPrimary(context),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getBackgroundSecondary(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: AppColors.getTextPrimary(context)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).notifications,
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                // Mark all as read
              },
              child: const Text(
                'Mark all',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications',
              message: 'You have no new notifications',
              actionLabel: AppLocalizations.of(context).back,
              onAction: () => Navigator.pop(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(notification: notification);
              },
            ),
    );
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'id': '1',
        'title': 'Your order is ready!',
        'message': 'Your order #ORD-001 is ready to pick up at table 5',
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
        'isRead': false,
        'type': 'order',
      },
      {
        'id': '2',
        'title': 'Special promotion',
        'message': '20% off all cappuccinos today',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'type': 'promotion',
      },
      {
        'id': '3',
        'title': 'Order confirmed',
        'message': 'Your order has been confirmed and is being prepared',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'isRead': true,
        'type': 'order',
      },
    ];
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationCard({required this.notification});

  IconData _getIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
      case 'info':
        return Icons.info_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.success;
      case 'promotion':
        return Colors.orange;
      case 'info':
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    } else {
      return '${difference.inDays} d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    final time = notification['time'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.getBackgroundSecondary(context)
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? AppColors.secondary.withValues(alpha: 0.1)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Mark as read and navigate
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconColor(type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(type),
                    color: _getIconColor(type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isRead ? FontWeight.w600 : FontWeight.bold,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.getTextSecondary(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTimeAgo(time),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getTextSecondary(context)
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
