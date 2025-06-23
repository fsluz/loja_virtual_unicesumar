import 'package:flutter/foundation.dart';

import './../models/models.dart';
import './repository.dart';

class AuthRepository {
  final AuthLocalRepository localRepository;
  final AuthRemoteRepository remoteRepository;

  AuthRepository(this.localRepository, this.remoteRepository);

  Future<LoginResponseModel?> findUserByUsername(String username) async {
    return await localRepository.getAuthByUsername(username);
  }

  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    // Primeiro tenta buscar local pelo username
    LoginResponseModel? auth = await localRepository.getAuthByUsername(request.username);

    if (auth != null) {
      if (kDebugMode) {
        print('Auth encontrado localmente para ${request.username}');
      }
      return auth;
    }

    if (kDebugMode) {
      print('Auth não encontrado localmente. Fazendo login remoto...');
    }
    auth = await remoteRepository.login(request);

    if (kDebugMode) {
      print('Login remoto bem-sucedido. Salvando localmente...');
    }
    await localRepository.saveAuth(request.username, auth!.token);

    return auth;
  }
}
