import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notification_catalog.dart';
import '../../domain/entities/notification_item.dart';

final notificationsProvider = Provider<List<NotificationItem>>(
  (ref) => NotificationCatalog.items,
);

final unreadNotificationsProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((item) => !item.isRead).length;
});
