import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../controllers/controllers.dart';
import './../views/views.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final MainNavigationController navigationController = Get.put(MainNavigationController());
  final CartController cartController = Get.find<CartController>();

  // GlobalKey do AddToCartIcon
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  // Função que executa animação da imagem
  late Function(GlobalKey widgetKey) runAddToCartAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CartController>().updateBadge();
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    OrdersPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  // Função que outras páginas podem chamar para animar
  void itemSelectedCartAnimations(GlobalKey gkImage) async {
    var cartQuantityItems = cartController.totalQuantity;

    await runAddToCartAnimation(gkImage);
    await cartKey.currentState?.runCartAnimation(cartQuantityItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      key: GlobalKey(),
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAnimation) {
        cartController.setRunAddToCartAnimation(
          (key) {
            runAnimation(key);
          },
        );
        cartController.setCartKey(cartKey);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(navigationController.selectedIndex.value == 0
              ? 'Loja Virtual'
              : navigationController.selectedIndex.value == 1
                  ? 'Meus Pedidos'
                  : navigationController.selectedIndex.value == 2
                      ? 'Meus Favoritos'
                      : 'Meu Perfil')),
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/cart');
              },
              child: AddToCartIcon(
                key: cartKey,
                icon: const Icon(Icons.shopping_cart),
                badgeOptions: BadgeOptions(
                  active: true,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        body: Obx(
          () {
            navigationController.totalPages = _pages.length;
            return _pages[navigationController.selectedIndex.value];
          },
        ), // << CORRETO
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationController.selectedIndex.value,
            onTap: navigationController.changePage,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
