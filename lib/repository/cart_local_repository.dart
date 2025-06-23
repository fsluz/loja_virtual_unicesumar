import 'package:sqflite/sqlite_api.dart';

import './../database/database.dart';
import './../models/models.dart';

class CartLocalRepository {
  Future<int> saveCart(int userId, String date) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'cart',
      {
        'userId': userId,
        'date': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CartModel?> getCartById(int cartId) async {
    final db = await AppDatabase().database;
    // 1️⃣ Busca o cart
    final maps = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );

    if (maps.isNotEmpty) {
      final cartMap = maps.first;

      // 2️⃣ Busca os produtos do cart
      final productMaps = await db.query(
        'cart_products',
        where: 'cartId = ?',
        whereArgs: [cartId],
      );

      final products = productMaps.map((map) => CartProductModel.fromJson(map)).toList();

      // 3️⃣ Monta o CartModel completo
      return CartModel(
        id: cartMap['id'] as int,
        userId: cartMap['userId'] as int,
        date: DateTime.parse(cartMap['date'].toString()),
        products: products,
      );
    }

    return null;
  }

  Future<void> deleteCart(int cartId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<void> removeCartProduct(int cartId, int productId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart_products',
      where: 'cartId = ? AND productId = ?',
      whereArgs: [cartId, productId],
    );
  }
}
