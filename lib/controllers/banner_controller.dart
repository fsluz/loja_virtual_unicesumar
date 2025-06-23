import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../repository/banner_repository.dart';

class BannerController extends GetxController {
  final BannerRepository bannerRepository;

  BannerController({required this.bannerRepository});

  // Lista de banners observável
  final RxList<BannerModel> bannerList = <BannerModel>[].obs;

  // Carregar banners
  Future<void> fetchBanners() async {
    try {
      final banners = await bannerRepository.getBanners();
      bannerList.assignAll(banners);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar banners: $e');
      }
    }
  }
}
