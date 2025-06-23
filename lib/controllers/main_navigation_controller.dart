import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  late int totalPages;

  void changePage(int index) {
    if (index < 0 || index >= totalPages) return;
    selectedIndex.value = index;
  }
}
