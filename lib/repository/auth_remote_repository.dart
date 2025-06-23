import './../services/auth_service.dart';
import './../models/models.dart';

class AuthRemoteRepository {
  final AuthService authService;

  AuthRemoteRepository(this.authService);

  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    return await authService.login(request);
  }
}
