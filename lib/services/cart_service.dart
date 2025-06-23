import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';

class CartService {
  Future<List<CartModel>> fetchCarts() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/carts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CartModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar carrinhos: ${response.statusCode}');
    }
  }

  Future<CartModel> fetchCartById(int id) async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/carts/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else {
      throw Exception('Erro ao carregar carrinho com id $id: ${response.statusCode}');
    }
  }
}
