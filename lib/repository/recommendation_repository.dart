import '../models/recommendation_model.dart';
import '../services/product_service.dart';

abstract class RecommendationRepository {
  Future<List<RecommendationModel>> getRecommendations();
  Future<List<RecommendationModel>> getPersonalizedRecommendations(String userId);
  Future<void> trackUserInteraction(String userId, String productId, String interactionType);
  Future<List<RecommendationModel>> getTrendingRecommendations();
}

class RecommendationRemoteRepository implements RecommendationRepository {
  final ProductService _productService;

  RecommendationRemoteRepository(this._productService);

  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    try {
      // Buscar produtos da API
      final products = await _productService.fetchProducts();
      
      // Gerar recomendações baseadas nos produtos
      final recommendations = <RecommendationModel>[];
      
      // Simular diferentes tipos de recomendações
      final reasons = [
        'Histórico de compras',
        'Tendência da semana',
        'Similar ao que você viu',
        'Mais vendidos',
        'Promoção especial',
      ];
      
      // Pegar alguns produtos aleatórios para criar recomendações
      final randomProducts = products.take(5).toList();
      
      for (int i = 0; i < randomProducts.length; i++) {
        final product = randomProducts[i];
        final score = 0.7 + (i * 0.05); // Score variando de 0.7 a 0.9
        final reason = reasons[i % reasons.length];
        
        recommendations.add(
          RecommendationModel.fromProduct(
            product,
            score: score,
            reason: reason,
          ),
        );
      }
      
      return recommendations;
    } catch (e) {
      // Fallback para dados simulados caso a API falhe
      return _getFallbackRecommendations();
    }
  }

  @override
  Future<List<RecommendationModel>> getPersonalizedRecommendations(String userId) async {
    // Implementação para recomendações personalizadas
    return await getRecommendations();
  }

  @override
  Future<void> trackUserInteraction(String userId, String productId, String interactionType) async {
    // Implementação para rastrear interações do usuário
    print('Tracking: $userId - $productId - $interactionType');
  }

  @override
  Future<List<RecommendationModel>> getTrendingRecommendations() async {
    // Implementação para recomendações em tendência
    return await getRecommendations();
  }

  // Método fallback com dados simulados
  List<RecommendationModel> _getFallbackRecommendations() {
    return [
      RecommendationModel(
        id: '1',
        productId: '1',
        title: 'Recomendado para você',
        description: 'Produto baseado no seu histórico de compras',
        score: 0.95,
        reason: 'Histórico de compras',
        createdAt: DateTime.now(),
      ),
      RecommendationModel(
        id: '2',
        productId: '2',
        title: 'Tendência da semana',
        description: 'Produtos mais populares no momento',
        score: 0.88,
        reason: 'Tendência',
        createdAt: DateTime.now(),
      ),
      RecommendationModel(
        id: '3',
        productId: '3',
        title: 'Similar ao que você viu',
        description: 'Produtos relacionados aos seus interesses',
        score: 0.82,
        reason: 'Similaridade',
        createdAt: DateTime.now(),
      ),
    ];
  }
} 