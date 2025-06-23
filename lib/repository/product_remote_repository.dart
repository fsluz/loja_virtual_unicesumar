import './../services/product_service.dart';
import './../models/product_model.dart';

class ProductRemoteRepository {
  final ProductService productService;

  ProductRemoteRepository(this.productService);

  Future<List<ProductModel>> fetchProducts() async {
    return await productService.fetchProducts();
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    return await productService.fetchProductsByCategory(category);
  }

  Future<ProductModel> fetchProductById(int id) async {
    return await productService.fetchProductById(id);
  }
}
