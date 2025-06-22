import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import '../views.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final ProductController categoryController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final categoria = Uri.decodeComponent(Get.parameters['category'] ?? '');

    // Dispara o carregamento ao entrar na página
    categoryController.fetchProductsByCategory(categoria);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria: $categoria'),
      ),
      body: Obx(() {
        if (categoryController.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.erro.isNotEmpty) {
          return Center(child: Text(categoryController.erro.value));
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
