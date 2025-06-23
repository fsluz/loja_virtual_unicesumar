import './../models/rating_model.dart';
import './repository.dart';

class RatingRepository {
  final RatingLocalRepository localRepository;

  RatingRepository(this.localRepository);

  Future<void> saveOrUpdateRating(int userId, int productId, RatingModel rating) async {
    await localRepository.saveOrUpdateRating(userId, productId, rating);
  }

  Future<RatingModel?> getRatingByUserAndProduct(int userId, int productId) async {
    return await localRepository.getRatingByUserAndProduct(userId, productId);
  }
}
