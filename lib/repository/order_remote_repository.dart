import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderRemoteRepository {
  final OrderService orderService;

  OrderRemoteRepository(this.orderService);

  Future<List<OrderModel>> fetchOrders() async {
    return await orderService.fetchOrders();
  }

  Future<void> saveOrder(OrderModel order) async {
    await orderService.saveOrder(order);
  }

  Future<void> deleteOrder(int orderId) async {
    await orderService.deleteOrder(orderId);
  }
}
