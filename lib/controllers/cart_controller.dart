import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../controllers/controllers.dart';
import './../repository/repository.dart';
import './../models/models.dart';
import 'package:loja_virtual_unicesumar/controllers/auth_controller.dart';
import 'package:loja_virtual_unicesumar/controllers/order_controller.dart';
import 'package:loja_virtual_unicesumar/models/cart_product_model.dart';
import 'package:loja_virtual_unicesumar/models/order_model.dart';
import 'package:loja_virtual_unicesumar/models/order_status.dart';
import 'package:loja_virtual_unicesumar/repository/cart_repository.dart';

import '../models/notification_model.dart';
import 'notification_controller.dart';

class CartController extends GetxController {
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  final Rx<CartModel?> cart = Rx<CartModel?>(null);
  final RxList<CartProductModel> cartProducts = <CartProductModel>[].obs;

  var carregandoFinalizar = false.obs;
  var erro = ''.obs;

  GlobalKey<CartIconKey>? cartKey;

  void setCartKey(GlobalKey<CartIconKey> key) {
    cartKey = key;
  }

  // Guarda a função de animação da imagem
  Function(GlobalKey)? _runAddToCartAnimation;

  void setRunAddToCartAnimation(Function(GlobalKey) animation) {
    _runAddToCartAnimation = animation;
  }

  Future<void> updateBadge() async {
    if (cartKey?.currentState != null) {
      cartKey!.currentState!.runCartAnimation(totalQuantity.toString());
    }
  }

  Future<void> limparCarrinho() async {
    if (cart.value == null) return;
    await cartRepository.deleteCartProducts(cart.value!.id);
    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
    await updateBadge();
  }

  Future<void> atualizarquantity(int productId, int novaQuantidade) async {
    if (cart.value == null) return;

    if (novaQuantidade > 0) {
      await cartRepository.updateProductQuantity(cart.value!.id, productId, novaQuantidade);
    } else {
      await cartRepository.removeCartProduct(cart.value!.id, productId);
    }

    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
    await updateBadge();
  }

  Future<void> loadCartForUser(int userId) async {
    try {
      await fetchCart(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar carrinho para user $userId: $e');
      }
    }
  }

  Future<void> fetchCart(int cartId) async {
    try {
      final fetchedCart = await cartRepository.getCartById(cartId);
      cart.value = fetchedCart;

      if (fetchedCart != null) {
        final products = await cartRepository.getCartProducts(fetchedCart.id);
        cartProducts.assignAll(products);
      } else {
        cartProducts.clear();
      }
      await updateBadge();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar carrinho: $e');
      }
    }
  }

  Future<void> addProductToCart(ProductModel produto, int quantity, {GlobalKey? gkImage}) async {
    try {
      carregandoFinalizar.value = true;
      final userId = Get.find<UserController>().user.value?.id;

      if (userId == null) {
        Get.snackbar('Erro', 'Para adicionar ao carrinho, você precisa estar logado.');
        return;
      }

      if (cart.value == null) {
        final newCartId = await cartRepository.saveCart(userId, DateTime.now().toIso8601String());
        cart.value = CartModel(id: newCartId, userId: userId, date: DateTime.now(), products: []);
      }

      final cartProduct = CartProductModel(
        productId: produto.id,
        quantity: quantity,
        title: produto.title,
        price: produto.price,
        imageUrl: produto.image,
      );
      await cartRepository.addProductToCart(cart.value!.id, cartProduct);

      final products = await cartRepository.getCartProducts(cart.value!.id);
      cartProducts.assignAll(products);

      if (gkImage != null && _runAddToCartAnimation != null) {
        await _runAddToCartAnimation!(gkImage);
      }
      await updateBadge();

      Get.snackbar(
        'Produto Adicionado!',
        '"${produto.title}" foi adicionado ao seu carrinho.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregandoFinalizar.value = false;
    }
  }

  Future<void> removeProductFromCart(int productId) async {
    try {
      if (cart.value == null) return;

      await cartRepository.removeCartProduct(cart.value!.id, productId);

      final products = await cartRepository.getCartProducts(cart.value!.id);
      cartProducts.assignAll(products);
      await updateBadge();
    } catch (e) {
      erro.value = e.toString();
    }
  }

  void finalizarPedido() async {
    final userController = Get.find<UserController>();
    if (userController.user.value == null) {
      Get.snackbar("Erro", "Você precisa estar logado para finalizar o pedido.");
      return;
    }

    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userController.user.value!.id,
      date: DateTime.now(),
      status: OrderStatus.emAndamento,
      products: cartProducts
          .map((p) => OrderProductModel(
                productId: p.productId,
                quantity: p.quantity,
                price: p.price,
              ))
          .toList(),
    );

    await Get.find<OrderController>().saveOrder(newOrder);

    final notificationController = Get.find<NotificationController>();
    notificationController.addNotification(
      title: 'Pedido Recebido!',
      body: 'Seu pedido #${newOrder.id.toString().substring(0, 5)} foi criado com sucesso.',
      type: NotificationType.pedido,
    );
    Future.delayed(const Duration(seconds: 5), () {
      notificationController.addNotification(
        title: 'Pedido Concluído!',
        body: 'Seu pedido #${newOrder.id.toString().substring(0, 5)} foi entregue.',
        type: NotificationType.pedido,
      );
    });
    
    await cartRepository.deleteCartProducts(cart.value?.id ?? 0);
    cartProducts.clear();
    update();
  }

  int get totalQuantity => cartProducts.fold(0, (sum, item) => sum + item.quantity);

  double get total => cartProducts.fold(0.0, (soma, item) => soma + item.price * item.quantity);

  void _onCartUpdated() {
    updateBadge();
  }
}
