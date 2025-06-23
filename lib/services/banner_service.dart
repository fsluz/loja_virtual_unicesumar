import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';

import 'dart:convert';
import 'dart:math';

class BannerService {
  Future<List<BannerModel>> fetchBanners() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ProductModel> products = data.map((json) => ProductModel.fromJson(json)).toList();

      // Embaralha a lista para ter produtos aleatórios
      products.shuffle(Random());

      // Seleciona no máximo 4 produtos
      final selectedProducts = products.take(4).toList();

      // Converte para BannerModel
      final banners = selectedProducts.map((product) {
        return BannerModel(
          id: product.id,
          imageUrl: product.image,
          title: product.title,
          price: product.price,
        );
      }).toList();

      return banners;
    } else {
      throw Exception('Erro ao carregar banners: ${response.statusCode}');
    }
  }
}
