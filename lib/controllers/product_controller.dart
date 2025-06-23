import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;

  ProductController({required this.productRepository});

  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> categoryProducts = <ProductModel>[].obs;

  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);

  var carregando = true.obs;
  var erro = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      carregando.value = true;
      erro.value = '';
      final products = await productRepository.fetchProducts();
      allProducts.assignAll(products);
      categoryProducts.assignAll(products);
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      carregando.value = true;
      erro.value = '';
      final products = await productRepository.fetchProductsByCategory(category);
      categoryProducts.assignAll(products);
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  Future<void> fetchProductById(int id) async {
    try {
      carregando.value = true;
      erro.value = '';
      final product = await productRepository.fetchProductById(id);
      selectedProduct.value = product;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  ProductModel? getProdutoById(int id) {
    try {
      final produtoCategoria = categoryProducts.firstWhereOrNull((produto) => produto.id == id);
      if (produtoCategoria != null) return produtoCategoria;
      
      return allProducts.firstWhereOrNull((produto) => produto.id == id);
    } catch (_) {
      return null;
    }
  }

  RxList<ProductModel> get productList => categoryProducts;
}
