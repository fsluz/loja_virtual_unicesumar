class OrderProductModel {
  final int productId;
  final int quantity;
  final double price;

  OrderProductModel({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      productId: json['productId'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
