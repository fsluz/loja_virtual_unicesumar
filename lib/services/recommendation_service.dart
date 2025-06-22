import '../models/recommendation_model.dart';
import '../models/product_model.dart';
import '../repository/recommendation_repository.dart';

class RecommendationService {
  final RecommendationRepository _repository;

  RecommendationService(this._repository);

  Future<List<RecommendationModel>> getRecommendations() async {
    return await _repository.getRecommendations();
  }

  Future<List<RecommendationModel>> getPersonalizedRecommendations(String userId) async {
    return await _repository.getPersonalizedRecommendations(userId);
  }

  Future<List<ProductModel>> getRecommendedProducts(String userId) async {
    // ignore: unused_local_variable
    final recommendations = await getPersonalizedRecommendations(userId);
    // Aqui você implementaria a lógica para buscar os produtos baseado nas recomendações
    return [];
  }

  Future<void> trackUserInteraction(String userId, String productId, String interactionType) async {
    await _repository.trackUserInteraction(userId, productId, interactionType);
  }

  Future<List<RecommendationModel>> getTrendingRecommendations() async {
    return await _repository.getTrendingRecommendations();
  }
} 