import 'package:sqflite/sqlite_api.dart';

import './../database/app_database.dart';

class FavoriteLocalRepository {
  Future<void> addFavorito(int userId, int productId, String dataFavorito) async {
    final db = await AppDatabase().database;
    await db.insert(
      'favoritos',
      {
        'userId': userId,
        'productId': productId,
        'dataFavorito': dataFavorito,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorito(int userId, int productId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'favoritos',
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoritosByUserId(int userId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'favoritos',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps;
  }

  Future<bool> isFavorito(int userId, int productId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'favoritos',
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );

    return maps.isNotEmpty;
  }
}
