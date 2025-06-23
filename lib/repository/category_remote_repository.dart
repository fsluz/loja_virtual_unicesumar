import './../services/category_service.dart';

class CategoryRemoteRepository {
  final CategoryService categoryService;

  CategoryRemoteRepository(this.categoryService);

  Future<List<String>> fetchCategories() async {
    return await categoryService.fetchCategories();
  }
}
