import 'dart:convert';
import 'package:http/http.dart' as http;
import '../common/common.dart';
import '../models/order_model.dart';

class OrderService {
  Future<List<OrderModel>> fetchOrders() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/carts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar pedidos: ${response.statusCode}');
    }
  }

  // Deixando métodos prontos para possível uso futuro
  Future<void> saveOrder(OrderModel order) async {
    // NÃO vamos usar no momento
  }

  Future<void> deleteOrder(int orderId) async {
    // NÃO vamos usar no momento
  }
}
