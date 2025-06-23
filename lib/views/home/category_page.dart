import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import '../views.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ProductController categoryController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  String? currentCategory;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  @override
  void didUpdateWidget(CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCategoryProducts();
  }

  void _loadCategoryProducts() {
    final categoria = Uri.decodeComponent(Get.parameters['category'] ?? '');
    
    // Só carrega se a categoria mudou
    if (currentCategory != categoria) {
      currentCategory = categoria;
      categoryController.fetchProductsByCategory(categoria);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria: ${Uri.decodeComponent(Get.parameters['category'] ?? '')}'),
      ),
      body: Obx(() {
        if (categoryController.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.erro.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar produtos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categoryController.erro.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadCategoryProducts(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (categoryController.productList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum produto encontrado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Não há produtos nesta categoria.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: categoryController.productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = categoryController.productList[index];
            final imageKey = GlobalKey();
            return ProductCard(
              key: imageKey,
              product: product,
              onTap: () {
                Get.to(() => ProductDetailPage(product: product));
              },
              onAddToCart: () {
                cartController.addProductToCart(product, 1, gkImage: imageKey);
              },
            );
          },
        );
      }),
    );
  }
}
