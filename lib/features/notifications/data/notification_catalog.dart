import '../domain/entities/notification_item.dart';

class NotificationCatalog {
  const NotificationCatalog._();

  static const items = <NotificationItem>[
    NotificationItem(
      icon: 'booking',
      title: 'Booking confirmed',
      message: 'Your Giza Pyramids Tour is confirmed.',
      time: 'Today',
    ),
    NotificationItem(
      icon: 'transport',
      title: 'Trip update',
      message: 'Your bus is on the way. Track your trip now.',
      time: 'Yesterday',
    ),
  ];
}
