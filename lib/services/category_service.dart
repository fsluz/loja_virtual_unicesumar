import 'dart:convert';
import 'package:http/http.dart' as http;
import '../common/common.dart';

class CategoryService {
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/products/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception('Erro ao carregar categorias: ${response.statusCode}');
    }
  }
}
