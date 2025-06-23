import './../models/models.dart';

class BannerModel {
  final int id;
  final String title;
  final double price;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory BannerModel.fromProduct(ProductModel product) {
    return BannerModel(
      id: product.id,
      title: product.title,
      price: product.price,
      imageUrl: product.image,
    );
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
