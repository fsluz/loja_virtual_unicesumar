import 'repository.dart';

class FavoritosRepository {
  final FavoriteLocalRepository localRepository;

  FavoritosRepository(this.localRepository);

  Future<void> addFavorito(int userId, int productId, String dataFavorito) async {
    await localRepository.addFavorito(userId, productId, dataFavorito);
  }

  Future<void> removeFavorito(int userId, int productId) async {
    await localRepository.removeFavorito(userId, productId);
  }

  Future<List<Map<String, dynamic>>> getFavoritosByUserId(int userId) async {
    return await localRepository.getFavoritosByUserId(userId);
  }

  Future<bool> isFavorito(int userId, int productId) async {
    return await localRepository.isFavorito(userId, productId);
  }
}
