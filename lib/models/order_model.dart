import 'models.dart';

class OrderModel {
  final int id;
  final int userId;
  final DateTime date;
  final OrderStatus status; // informar na video aula que foi adicionado o status
  final List<OrderProductModel> products;

  OrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      status: OrderStatusExtension.fromString(json['status'] ?? 'Concluído'),
      products: (json['products'] as List<dynamic>)
          .map((item) => OrderProductModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'status': status.label,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
