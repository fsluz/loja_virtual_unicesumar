import './../repository/repository.dart';
import './../models/models.dart';

class BannerRepository {
  final BannerRemoteRepository bannerRemoteRepository;

  BannerRepository(this.bannerRemoteRepository);

  Future<List<BannerModel>> getBanners() async {
    return await bannerRemoteRepository.fetchBanners();
  }
}
