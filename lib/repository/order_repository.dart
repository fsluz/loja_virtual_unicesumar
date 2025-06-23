import 'package:flutter/foundation.dart';
import './../repository/repository.dart';

import './../models/models.dart';

class OrderRepository {
  final OrderLocalRepository localRepository;
  final OrderRemoteRepository remoteRepository;

  OrderRepository(this.localRepository, this.remoteRepository);

  Future<List<OrderModel>> getOrders() async {
    // Primeiro tenta buscar local
    List<OrderModel> orders = await localRepository.getOrders();

    if (orders.isNotEmpty) {
      if (kDebugMode) {
        print('Pedidos encontrados localmente');
      }
      return orders;
    }

    if (kDebugMode) {
      print('Pedidos não encontrados localmente. Buscando remoto...');
    }
    orders = await remoteRepository.fetchOrders();

    if (orders.isNotEmpty) {
      if (kDebugMode) {
        print('Pedidos encontrados remoto. Salvando localmente...');
      }
      for (var order in orders) {
        await localRepository.saveOrder(order);
      }
    } else {
      if (kDebugMode) {
        print('Nenhum pedido encontrado na API.');
      }
    }

    return orders;
  }

  Future<void> saveOrder(OrderModel order) async {
    await localRepository.saveOrder(order);
  }

  Future<void> deleteOrder(int orderId) async {
    await localRepository.deleteOrder(orderId);
  }
}
