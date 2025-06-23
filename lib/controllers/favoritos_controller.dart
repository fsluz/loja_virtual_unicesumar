import 'package:get/get.dart';

import '../repository/repository.dart';
import 'controllers.dart';

class FavoritosController extends GetxController {
  final FavoritosRepository favoritosRepository;

  FavoritosController({required this.favoritosRepository});

  final RxList<int> favoritos = <int>[].obs;

  Future<void> loadFavoritosForUser(int? userId) async {
    if (userId == null) {
      return;
    }

    final favoritosData = await favoritosRepository.getFavoritosByUserId(userId);
    favoritos.assignAll(favoritosData.map((fav) => fav['productId'] as int));
  }

  Future<void> toggleFavorito(int productId) async {
    final userId = Get.find<UserController>().user.value?.id;

    if (userId == null) {
      return;
    }

    if (favoritos.contains(productId)) {
      await favoritosRepository.removeFavorito(userId, productId);
      favoritos.remove(productId);
    } else {
      await favoritosRepository.addFavorito(
        userId,
        productId,
        DateTime.now().toIso8601String(),
      );
      favoritos.add(productId);
    }
  }

  bool isFavorito(int productId) {
    return favoritos.contains(productId);
  }

  bool isFavoritoSync(int productId) {
    return favoritos.contains(productId);
  }
}
