import './../repository/repository.dart';

class CategoryRepository {
  final CategoryRemoteRepository categoryRemoteRepository;

  CategoryRepository(this.categoryRemoteRepository);

  Future<List<String>> fetchCategories() async {
    return await categoryRemoteRepository.fetchCategories();
  }
}
