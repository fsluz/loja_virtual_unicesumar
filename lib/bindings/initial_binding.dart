import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../repository/repository.dart';
import '../services/services.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    final productService = ProductService();
    final categoryService = CategoryService();
    final bannerService = BannerService();
    final userService = UserService();
    final authService = AuthService();

    // Remote Repositories
    final productRemoteRepository = ProductRemoteRepository(productService);
    final categoryRemoteRepository = CategoryRemoteRepository(categoryService);
    final bannerRemoteRepository = BannerRemoteRepository(bannerService);

    final authRemoteRepository = AuthRemoteRepository(authService);
    final authLocalRepository = AuthLocalRepository();

    // Repositories
    final authRepository = AuthRepository(authLocalRepository, authRemoteRepository);
    Get.put(authRepository);

    final productRepository = ProductRepository(productRemoteRepository);
    Get.put(productRepository);

    final categoryRepository = CategoryRepository(categoryRemoteRepository);
    Get.put(categoryRepository);

    final bannerRepository = BannerRepository(bannerRemoteRepository);
    Get.put(bannerRepository);

    final userLocalRepository = UserLocalRepository();
    final userRemoteRepository = UserRemoteRepository(userService);
    final userRepository = UserRepository(userLocalRepository, userRemoteRepository);
    Get.put(userRepository);

    final cartLocalRepository = CartLocalRepository();
    final cartProductsLocalRepository = CartProductsLocalRepository();
    final cartRepository = CartRepository(cartLocalRepository, cartProductsLocalRepository);
    Get.put(cartRepository);
    Get.put(CartController(cartRepository: cartRepository)); // OK

    final favoritosRepository = FavoritosRepository(FavoriteLocalRepository());
    Get.put(favoritosRepository);
    Get.put(FavoritosController(favoritosRepository: favoritosRepository)); // ✅ ADD AQUI

    // Sistema de Recomendações
    final recommendationRepository = RecommendationRemoteRepository(productService);
    final recommendationService = RecommendationService(recommendationRepository);
    Get.put(recommendationService);
    Get.put(RecommendationController());

    // Controllers globais
    Get.put(MainNavigationController());
    Get.put(ThemeController());

    Get.put(HomeController(
      bannerRepository: bannerRepository,
      categoryRepository: categoryRepository,
      productRepository: productRepository,
    ));

    Get.put(UserController(userRepository: userRepository)); // OK

    Get.put(BannerController(bannerRepository: bannerRepository));
    Get.put(CategoryController(categoryRepository: categoryRepository));
    Get.put(ProductController(productRepository: productRepository));
    Get.put(AuthController(authRepository: authRepository));

    // Order
    Get.put(OrderService());
    Get.put(OrderRemoteRepository(Get.find<OrderService>()));
    Get.put(OrderLocalRepository());
    Get.put(OrderRepository(
      Get.find<OrderLocalRepository>(),
      Get.find<OrderRemoteRepository>(),
    ));
    Get.put(OrderController(orderRepository: Get.find<OrderRepository>()));

    // Carregar dados do usuario se tiver
    final box = GetStorage();
    String? userJson = box.read('usuario');

    if (userJson != null) {
      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      Get.find<UserController>().user.value = user;
      Get.find<AuthController>().logado.value = true;

      // Carregar dados do user:
      Get.find<FavoritosController>().loadFavoritosForUser(user.id);
      Get.find<CartController>().loadCartForUser(user.id);
      Get.find<OrderController>().fetchOrdersForUser(user.id);
    }
  }
}
