import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';

import '../database/app_database.dart';
import '../models/models.dart';

class OrderLocalRepository {
  Future<List<OrderModel>> getOrders() async {
    final db = await AppDatabase().database;
    final orderMaps = await db.query('orders');

    List<OrderModel> orders = [];

    try {
      for (var orderMap in orderMaps) {
        final productMaps = await db.query(
          'order_products',
          where: 'orderId = ?',
          whereArgs: [orderMap['id']],
        );

        final products = productMaps
            .map((p) => OrderProductModel(
                  productId: p['productId'] as int,
                  quantity: p['quantity'] as int,
                  price: p['price'] as double,
                ))
            .toList();

        orders.add(OrderModel(
          id: orderMap['id'] as int,
          userId: orderMap['userId'] as int,
          date: DateTime.parse(orderMap['date'] as String),
          status: OrderStatusExtension.fromString(orderMap['status'] as String),
          products: products,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos: $e');
      }
    }

    return orders;
  }

  Future<void> saveOrder(OrderModel order) async {
    final db = await AppDatabase().database;

    try {
      // Salva pedido
      try {
        await db.insert(
          'orders',
          {
            'id': order.id,
            'userId': order.userId,
            'date': order.date.toIso8601String(),
            'status': order.status.label,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        throw Exception('Erro ao salvar pedido: $e');
      }

      // Remove produtos antigos do pedido (se houver)
      try {
        await db.delete(
          'order_products',
          where: 'orderId = ?',
          whereArgs: [order.id],
        );
      } catch (e) {
        throw Exception('Erro ao remover produtos antigos do pedido: $e');
      }

      // Salva produtos do pedido
      for (var product in order.products) {
        await db.insert(
          'order_products',
          {
            'orderId': order.id,
            'productId': product.productId,
            'quantity': product.quantity,
            'price': product.price,
          },
        );
      }
    } catch (e) {
      throw Exception('Erro ao salvar pedido: $e');
    }
  }

  Future<void> deleteOrder(int orderId) async {
    final db = await AppDatabase().database;

    try {
      // Remove produtos primeiro
      try {
        await db.delete(
          'order_products',
          where: 'orderId = ?',
          whereArgs: [orderId],
        );
      } catch (e) {
        throw Exception('Erro ao remover produtos do pedido: $e');
      }

      // Remove o pedido
      try {
        await db.delete(
          'orders',
          where: 'id = ?',
          whereArgs: [orderId],
        );
      } catch (e) {
        throw Exception('Erro ao remover pedido: $e');
      }
    } catch (e) {
      throw Exception('Erro ao deletar pedido: $e');
    }
  }
}
