import 'product_model.dart';

class RecommendationModel {
  final String id;
  final String productId;
  final String title;
  final String description;
  final double score;
  final String reason;
  final DateTime createdAt;
  final ProductModel? product; // Produto associado à recomendação

  RecommendationModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.description,
    required this.score,
    required this.reason,
    required this.createdAt,
    this.product,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'],
      productId: json['productId'],
      title: json['title'],
      description: json['description'],
      score: json['score'].toDouble(),
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      product: json['product'] != null ? ProductModel.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'description': description,
      'score': score,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }

  // Factory para criar recomendação a partir de um produto
  factory RecommendationModel.fromProduct(
    ProductModel product, {
    required double score,
    required String reason,
  }) {
    return RecommendationModel(
      id: 'rec_${product.id}',
      productId: product.id.toString(),
      title: 'Recomendado para você',
      description: product.title,
      score: score,
      reason: reason,
      createdAt: DateTime.now(),
      product: product,
    );
  }
} 