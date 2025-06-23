import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';

class ProductService {
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/products'));

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar produtos: ${response.statusCode}');
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/products/category/$category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos: ${response.statusCode}');
    }
  }

  Future<ProductModel> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/products/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Erro ao carregar produto com id $id: ${response.statusCode}');
    }
  }
}
