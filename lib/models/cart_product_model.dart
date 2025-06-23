class CartProductModel {
  final int productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl; // Adicionado para imagem do produto

  double get subtotal => quantity * price;

  CartProductModel({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      productId: map['productId'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
