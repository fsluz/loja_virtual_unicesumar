import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/recommendation_controller.dart';
import '../../widgets/recommendation_card.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecommendationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações para Você'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshRecommendations(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
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
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshRecommendations(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (controller.recommendations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.recommend,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma recomendação disponível',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Continue navegando para receber recomendações personalizadas',
                  style: TextStyle(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshRecommendations,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = controller.recommendations[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RecommendationCard(recommendation: recommendation),
              );
            },
          ),
        );
      }),
    );
  }
} 