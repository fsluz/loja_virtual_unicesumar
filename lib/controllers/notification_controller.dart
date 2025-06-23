import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:loja_virtual_unicesumar/models/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  Timer? _promoTimer;

  List<NotificationModel> get notifications => _notifications.reversed.toList();

  @override
  void onInit() {
    super.onInit();
    _startPromoTimer();
  }

  @override
  void onClose() {
    _promoTimer?.cancel();
    super.onClose();
  }

  void _startPromoTimer() {
    _promoTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _generatePromoNotification();
    });
  }

  void _generatePromoNotification() {
    final promos = [
      {'title': 'Oferta Imperdível!', 'body': 'Descontos de até 50% em eletrônicos!'},
      {'title': 'Queima de Estoque!', 'body': 'Moda masculina com preços incríveis.'},
      {'title': 'Sua Chance de Ouro!', 'body': 'Compre um e leve outro em jóias selecionadas.'},
      {'title': 'Frete Grátis!', 'body': 'Aproveite o frete grátis para todo o Brasil.'},
    ];
    final randomPromo = promos[Random().nextInt(promos.length)];
    addNotification(
      title: randomPromo['title']!,
      body: randomPromo['body']!,
      type: NotificationType.promocao,
    );
  }

  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
  }) {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
    );

    _notifications.add(newNotification);

    if (_notifications.length > 5) {
      _notifications.removeAt(0);
    }
    _updateUnreadCount();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _updateUnreadCount();
    }
  }
  
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    unreadCount.value = _notifications.where((n) => !n.isRead).length;
  }
} 