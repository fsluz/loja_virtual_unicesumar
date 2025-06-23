import './../models/models.dart';

class CartModel {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartProductModel> products;

  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        userId: json['userId'],
        date: DateTime.parse(json['date']),
        products: (json['products'] as List<dynamic>)
            .map((item) => CartProductModel.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((item) => item.toJson()).toList()
    };
  }
}
