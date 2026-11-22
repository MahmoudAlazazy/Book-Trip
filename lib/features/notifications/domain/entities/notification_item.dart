class NotificationItem {
  const NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });

  final String icon;
  final String title;
  final String message;
  final String time;
  final bool isRead;
}
