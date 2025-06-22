import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual_unicesumar/controllers/notification_controller.dart';
import 'package:loja_virtual_unicesumar/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read),
            tooltip: 'Marcar todas como lidas',
            onPressed: () {
              controller.markAllAsRead();
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma notificação ainda.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    _getIconForType(notification.type),
                    color: notification.isRead
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(notification.createdAt, locale: 'pt_BR'),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  onTap: () {
                    if (!notification.isRead) {
                      controller.markAsRead(notification.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.pedido:
        return Icons.shopping_bag;
      case NotificationType.promocao:
        return Icons.local_offer;
      case NotificationType.sistema:
        return Icons.info;
    }
  }
} 