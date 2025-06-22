import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import './../../widgets/widgets.dart';
import './../../views/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cartController = Get.find<CartController>();
  final controller = Get.find<HomeController>();
  final recommendationController = Get.find<RecommendationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Banners
              BannerCarousel(banners: controller.banners),

              const SizedBox(height: 16),

              /// Categorias
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final categoria = controller.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryTile(
                        category: categoria,
                        onTap: () {
                          Get.toNamed('/category/${Uri.encodeComponent(categoria)}');
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Seção de Recomendações
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recomendações para Você',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/recommendations'),
                    child: const Text('Ver Todas'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (recommendationController.isLoading.value)
                const RecommendationLoadingWidget()
              else if (recommendationController.recommendations.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendationController.recommendations.take(3).length,
                    itemBuilder: (context, index) {
                      final recommendation = recommendationController.recommendations[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagem do produto
                              SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: recommendation.product?.image != null
                                    ? Image.network(
                                        recommendation.product!.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                      ),
                              ),
                              // Conteúdo do card
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Top content
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            recommendation.title,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            recommendation.product?.title ?? recommendation.description,
                                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),

                                      // Bottom content
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: recommendation.score >= 0.8 ? Colors.green : Colors.orange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${(recommendation.score * 100).toInt()}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.arrow_forward, size: 16),
                                            onPressed: () => Get.toNamed('/recommendations'),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              /// Produtos em destaque
              const Text(
                'Produtos em destaque',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.featuredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = controller.featuredProducts[index];
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
              ),
              
              // Padding bottom para evitar overflow com o bottom navigation
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}
