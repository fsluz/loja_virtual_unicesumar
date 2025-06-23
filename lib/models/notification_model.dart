enum NotificationType {
  pedido,
  promocao,
  sistema,
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
} 