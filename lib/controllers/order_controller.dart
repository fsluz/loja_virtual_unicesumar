import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';
import './user_controller.dart';

class OrderController extends GetxController {
  final OrderRepository orderRepository;

  OrderController({required this.orderRepository});

  final RxList<OrderModel> orderList = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchOrdersForUser(int userId) async {
    try {
      isLoading.value = true;
      final orders = await orderRepository.getOrders();

      // Filtra e ordena por data decrescente
      orderList.assignAll(
        orders.where((order) => order.userId == userId).toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos do user $userId: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    try {
      await orderRepository.saveOrder(order);
      await fetchOrdersForUser(order.userId); // Atualiza lista após salvar
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar pedido: $e');
      }
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      await orderRepository.deleteOrder(orderId);
      int? userId = Get.find<UserController>().user.value?.id;
      if (userId != null) {
        await fetchOrdersForUser(userId); // Atualiza lista após deletar
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao deletar pedido: $e');
      }
    }
  }
}
