import 'package:sqflite/sqlite_api.dart';

import './../database/app_database.dart';
import './../models/models.dart';

class RatingLocalRepository {
  Future<void> saveOrUpdateRating(int userId, int productId, RatingModel rating) async {
    final db = await AppDatabase().database;
    await db.insert(
      'rating',
      {
        'userId': userId,
        'productId': productId,
        'rate': rating.rate,
        'count': rating.count,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<RatingModel?> getRatingByUserAndProduct(int userId, int productId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'rating',
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return RatingModel(
        rate: map['rate'] as double,
        count: map['count'] as int,
      );
    }

    return null;
  }
}
