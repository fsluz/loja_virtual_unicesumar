import 'package:get/get.dart';
import '../models/recommendation_model.dart';
import '../services/recommendation_service.dart';

class RecommendationController extends GetxController {
  final RecommendationService _service = Get.find<RecommendationService>();
  
  final RxList<RecommendationModel> recommendations = <RecommendationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _service.getRecommendations();
      recommendations.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Erro ao carregar recomendações: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshRecommendations() async {
    await loadRecommendations();
  }

  List<RecommendationModel> getTopRecommendations({int limit = 5}) {
    final sorted = recommendations.toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return sorted.take(limit).toList();
  }

  List<RecommendationModel> getRecommendationsByCategory(String category) {
    return recommendations
        .where((rec) => rec.reason.contains(category))
        .toList();
  }
} 