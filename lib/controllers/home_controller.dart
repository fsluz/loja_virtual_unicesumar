import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';

class HomeController extends GetxController {
  final BannerRepository bannerRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  HomeController({
    required this.bannerRepository,
    required this.categoryRepository,
    required this.productRepository,
  });

  final banners = <BannerModel>[].obs;
  final categories = <String>[].obs;
  final featuredProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      /// Banners
      final bannersApi = await bannerRepository.getBanners();
      banners.assignAll(bannersApi);

      /// Categories
      final categoriesApi = await categoryRepository.fetchCategories();
      categories.assignAll(categoriesApi);

      /// Featured Products
      final productsApi = await productRepository.fetchProducts();
      featuredProducts.assignAll(productsApi.take(30).toList());
    } catch (e) {
      errorMessage.value = 'Erro ao carregar a Home: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
