import './../services/banner_service.dart';
import './../models/banner_model.dart';

class BannerRemoteRepository {
  final BannerService bannerService;

  BannerRemoteRepository(this.bannerService);

  Future<List<BannerModel>> fetchBanners() async {
    return await bannerService.fetchBanners();
  }
}
