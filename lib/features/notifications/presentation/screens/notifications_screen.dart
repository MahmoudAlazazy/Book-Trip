import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_item.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsProvider);
    final colors = Theme.of(context).colorScheme;
    final filtered = notifications.where((notification) {
      if (_filter == 'read') return notification.isRead;
      if (_filter == 'unread') return !notification.isRead;
      return true;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Notifications')),
        backgroundColor: colors.surface,
        foregroundColor: AppColors.darkTeal,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? Center(child: Text(context.tr('No notifications yet')))
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [
                Text(
                  unreadCount == 0
                      ? context.tr('You are all caught up')
                      : '$unreadCount ${context.tr('new notifications')}',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                _FilterBar(
                  selected: _filter,
                  onSelected: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(context.tr('No notifications found')),
                    ),
                  ),
                ...filtered.map(
                  (notification) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NotificationTile(
                      notification: notification,
                      onTap: () =>
                          _showNotificationDetails(context, notification),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showNotificationDetails(
    BuildContext context,
    NotificationItem notification,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFDCE8E6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.darkTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr(notification.title),
                      style: const TextStyle(
                        color: AppColors.darkTeal,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr(notification.message),
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    height: 1.55,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr(notification.time),
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.tr('Close')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _FilterChip(
          label: context.tr('All'),
          value: 'all',
          selected: selected,
          onSelected: onSelected,
        ),
      ),
      Expanded(
        child: _FilterChip(
          label: context.tr('Read'),
          value: 'read',
          selected: selected,
          onSelected: onSelected,
        ),
      ),
      Expanded(
        child: _FilterChip(
          label: context.tr('Unread'),
          value: 'unread',
          selected: selected,
          onSelected: onSelected,
        ),
      ),
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });
  final String label, value, selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 6),
    child: SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(11),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected == value
                  ? AppColors.teal.withValues(alpha: .16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: selected == value
                    ? AppColors.teal
                    : const Color(0xFFDCE8E6),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected == value
                    ? AppColors.darkTeal
                    : Colors.blueGrey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final NotificationItem notification;
  final VoidCallback onTap;

  IconData get _icon => notification.icon == 'booking'
      ? Icons.confirmation_num_outlined
      : Icons.directions_bus_outlined;

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead
            ? Theme.of(context).colorScheme.surface
            : AppColors.teal.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? const Color(0xFFE2EAE8)
              : AppColors.teal.withValues(alpha: .28),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: AppColors.teal.withValues(alpha: .14),
                child: Icon(_icon, color: AppColors.darkTeal),
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
                            context.tr(notification.title),
                            style: const TextStyle(
                              color: AppColors.darkTeal,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!isRead)
                          const Icon(
                            Icons.circle,
                            size: 9,
                            color: AppColors.teal,
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      context.tr(notification.message),
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr(notification.time),
                      style: TextStyle(
                        color: Colors.blueGrey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
