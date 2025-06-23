import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import './../repository/repository.dart';
import './../models/models.dart';
import './controllers.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  var logado = false.obs;
  var carregando = false.obs;
  var erro = ''.obs;
  final box = GetStorage();

  // Resposta do login
  final Rx<LoginResponseModel?> loginResponse = Rx<LoginResponseModel?>(null);

  // Efetuar login
  Future<void> login(LoginRequestModel request) async {
    try {
      carregando.value = true;
      erro.value = '';

      final response = await authRepository.login(request);
      loginResponse.value = response;

      if (response != null) {
        logado.value = true;
        box.write('token', response.token);

        // Buscar o user pelo username do LoginRequestModel
        final userModel =
            await Get.find<UserController>().userRepository.getUserByUsername(request.username);

        if (userModel != null) {
          box.write('usuario', jsonEncode(userModel.toJson()));
          Get.find<UserController>().user.value = userModel;

          // Carregar dados do user:
          Get.find<FavoritosController>().loadFavoritosForUser(userModel.id);
          Get.find<CartController>().loadCartForUser(userModel.id);
          Get.find<OrderController>().fetchOrdersForUser(userModel.id);
        }
      } else {
        logado.value = false;
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  void logout() {
    logado.value = false;
    box.remove('token');
    box.remove('usuario');

    Get.snackbar(
      'Logout',
      'Você saiu da sua conta com sucesso.',
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.logout, color: Colors.white),
      duration: const Duration(seconds: 3),
    );

    Get.offAllNamed('/');
  }
}
