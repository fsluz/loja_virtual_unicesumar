import './../database/app_database.dart';
import './../models/models.dart';

class CartProductsLocalRepository {
  /// Adiciona um produto ao carrinho.
  /// Se o produto já existir, incrementa a quantidade.
  Future<void> addProduct(int cartId, CartProductModel cartProduct) async {
    final db = await AppDatabase().database;

    final existingProducts = await db.query(
      'cart_products',
      where: 'cartId = ? AND productId = ?',
      whereArgs: [cartId, cartProduct.productId],
    );

    if (existingProducts.isNotEmpty) {
      final existingQuantity = existingProducts.first['quantity'] as int;
      final newQuantity = existingQuantity + cartProduct.quantity;
      await db.update(
        'cart_products',
        {'quantity': newQuantity},
        where: 'cartId = ? AND productId = ?',
        whereArgs: [cartId, cartProduct.productId],
      );
    } else {
      await db.insert(
        'cart_products',
        {
          'cartId': cartId,
          'productId': cartProduct.productId,
          'quantity': cartProduct.quantity,
          'title': cartProduct.title,
          'price': cartProduct.price,
          'imageUrl': cartProduct.imageUrl,
        },
      );
    }
  }

  /// Atualiza a quantidade de um produto específico para um valor exato.
  Future<void> updateQuantity(int cartId, int productId, int newQuantity) async {
    final db = await AppDatabase().database;
    await db.update(
      'cart_products',
      {'quantity': newQuantity},
      where: 'cartId = ? AND productId = ?',
      whereArgs: [cartId, productId],
    );
  }

  Future<void> removeProduct(int cartId, int productId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart_products',
      where: 'cartId = ? AND productId = ?',
      whereArgs: [cartId, productId],
    );
  }

  Future<List<CartProductModel>> getCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );

    // Convertendo cada Map para CartProductModel
    return maps.map((map) => CartProductModel.fromJson(map)).toList();
  }

  Future<void> deleteCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );
  }
}
