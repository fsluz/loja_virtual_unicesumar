import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import '../models/models.dart';
import '../common/common.dart';

class AuthService {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await http.post(
      Uri.parse('${Common.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return LoginResponseModel.fromJson(data);
    } else {
      // Tentativa de buscar usuário localmente
      final localUser = await getUserByNameAndPassword(request.username, request.password);
      if (localUser != null) {
        return LoginResponseModel(
          token:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInVzZXIiOiJqb2huZCIsImlhdCI6MTc1MDM3NzI4NH0.weCwGHqmhHxCcS7F99jmqpwFlC8Ei1SMXrMLFyrGzaw',
        );
      }

      // Caso não encontre localmente, lança exceção original
      throw Exception('Erro no login: ${response.statusCode}');
    }
  }

  Future<UserModel?> getUserByNameAndPassword(String userName, String password) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [userName, password],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return UserModel(
        id: map['id'] as int,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        name: NameModel(
          firstname: map['firstname'] as String,
          lastname: map['lastname'] as String,
        ),
        address: AddressModel(
          city: map['city'] as String,
          street: map['street'] as String,
          number: map['number'] as int,
          zipcode: map['zipcode'] as String,
          geolocation: GeolocationModel(
            lat: map['lat'] as String,
            long: map['long'] as String,
          ),
        ),
        phone: map['phone'] as String,
      );
    }

    return null;
  }
}
