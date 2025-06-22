import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import './widgets/widgets.dart';
import './views/views.dart';
import 'bindings/initial_binding.dart';
import 'controllers/theme_controller.dart';
import 'package:loja_virtual_unicesumar/views/home/product_detail_page.dart';
import 'package:loja_virtual_unicesumar/views/order/order_detail_page.dart';
import 'package:loja_virtual_unicesumar/views/order/orders_page.dart';
import 'package:loja_virtual_unicesumar/views/recommendations/recommendations_page.dart';
import 'package:loja_virtual_unicesumar/views/user/edit_profile_page.dart';
import 'package:loja_virtual_unicesumar/views/user/login_page.dart';
import 'package:loja_virtual_unicesumar/views/user/profile_page.dart';
import 'package:loja_virtual_unicesumar/views/user/sign_up_page.dart';
import 'package:loja_virtual_unicesumar/widgets/main_navigation_page.dart';

import 'models/notification_model.dart';
import 'views/notification/notifications_page.dart';

Future<void> main() async {
  // Registrar os services globais

  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(); // Inicializa o GetStorage
  // Inicializa locale para pt_BR
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja de Produtos',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system, // Será controlado pelo ThemeController
      initialBinding: InitialBinding(),
      onInit: () {
        // Aplica o tema salvo após a inicialização
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final themeController = Get.find<ThemeController>();
          Get.changeThemeMode(themeController.themeMode);
        });
      },
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainNavigationPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(
            name: '/product-detail', 
            page: () => ProductDetailPage(product: Get.arguments)),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/orders', page: () => OrdersPage()),
        GetPage(
            name: '/order-detail', 
            page: () => OrderDetailPage(order: Get.arguments)),
        GetPage(name: '/favorites', page: () => FavoritesPage()),
        GetPage(
            name: '/recommendations',
            page: () => const RecommendationsPage()),
        GetPage(name: '/notifications', page: () => const NotificationsPage()),
      ],
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: StadiumBorder(),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.blue,
        selectedColor: Colors.orange,
        secondarySelectedColor: Colors.orange,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: StadiumBorder(),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        labelLarge: TextStyle(fontSize: 16, color: Colors.white),
        labelMedium: TextStyle(fontSize: 14, color: Colors.white),
        labelSmall: TextStyle(fontSize: 12, color: Colors.white),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.blue,
        selectedColor: Colors.orange,
        secondarySelectedColor: Colors.orange,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white70),
        fillColor: const Color(0xFF1E1E1E),
        filled: true,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
    );
  }
}
