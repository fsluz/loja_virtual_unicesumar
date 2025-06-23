import '../services/services.dart';
import '../models/models.dart';

class UserRemoteRepository {
  final UserService userService;

  UserRemoteRepository(this.userService);

  Future<UserModel?> fetchUserById(int id) async {
    return await userService.fetchUserById(id);
  }
}
