import './product_remote_repository.dart';
import './../models/models.dart';

class ProductRepository {
  final ProductRemoteRepository remoteRepository;

  ProductRepository(this.remoteRepository);

  Future<List<ProductModel>> fetchProducts() async {
    return await remoteRepository.fetchProducts();
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    return await remoteRepository.fetchProductsByCategory(category);
  }

  Future<ProductModel> fetchProductById(int id) async {
    return await remoteRepository.fetchProductById(id);
  }
}
