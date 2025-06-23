import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual_unicesumar/controllers/notification_controller.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find();

    return Obx(
      () => badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 3),
        showBadge: controller.unreadCount.value > 0,
        badgeContent: Text(
          controller.unreadCount.value.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        child: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Get.toNamed('/notifications');
          },
        ),
      ),
    );
  }
} 