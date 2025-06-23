import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';

class UserService {
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar usuários: ${response.statusCode}');
    }
  }

  Future<UserModel> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('${Common.baseUrl}/users/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Erro ao carregar usuário com id $id: ${response.statusCode}');
    }
  }
}
