import './../models/models.dart';
import './repository.dart';

class CartRepository {
  final CartLocalRepository local;
  final CartProductsLocalRepository productsLocal;

  CartRepository(this.local, this.productsLocal);

  Future<CartModel?> getCartById(int id) async {
    return await local.getCartById(id);
  }

  Future<int> saveCart(int userId, String date) async {
    return await local.saveCart(userId, date);
  }

  Future<void> deleteCart(int cartId) async {
    await local.deleteCart(cartId);
  }

  Future<void> addProductToCart(int cartId, CartProductModel product) async {
    await productsLocal.addProduct(cartId, product);
  }

  Future<void> updateProductQuantity(int cartId, int productId, int newQuantity) async {
    await productsLocal.updateQuantity(cartId, productId, newQuantity);
  }

  Future<void> removeCartProduct(int cartId, int productId) async {
    await productsLocal.removeProduct(cartId, productId);
  }

  Future<List<CartProductModel>> getCartProducts(int cartId) async {
    return await productsLocal.getCartProducts(cartId);
  }

  Future<void> deleteCartProducts(int cartId) async {
    await productsLocal.deleteCartProducts(cartId);
  }
}
