import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/user_model.dart';

class UserController extends GetxController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  // Usuário atual observável
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  var carregando = false.obs;
  var erro = ''.obs;

  // Carregar um usuário pelo id
  Future<void> fetchUserById(int id) async {
    try {
      final fetchedUser = await userRepository.getUserById(id);
      user.value = fetchedUser;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar usuário: $e');
      }
    }
  }

  // Salvar um usuário
  Future<void> saveUser(UserModel userModel) async {
    try {
      carregando.value = true;
      erro.value = '';
      await userRepository.saveUser(userModel);
      user.value = userModel;
      carregando.value = false;
    } catch (e) {
      erro.value = e.toString();
    }
  }

  Future<bool> updateUserReturningSuccess(UserModel userModel) async {
    try {
      carregando.value = true;
      erro.value = '';
      await userRepository.saveUser(userModel);
      user.value = userModel;
      carregando.value = false;
      return true;
    } catch (e) {
      erro.value = e.toString();
      carregando.value = false;
      return false;
    }
  }
}
