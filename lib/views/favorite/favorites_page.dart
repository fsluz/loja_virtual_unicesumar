import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final favoritosController = Get.find<FavoritosController>();
  final usuarioController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        final favoritos = favoritosController.favoritos;

        // *** aqui usamos diretamente authController.logado.value ***
        if (!authController.logado.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Você não está logado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Faça login para visualizar seus produtos favoritos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        'Fazer Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Future.microtask(() {
                          Get.toNamed('/login');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Logado mas sem favoritos
        if (favoritos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nenhum favorito encontrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Adicione produtos aos seus favoritos\npara visualizá-los aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          );
        }

        // Logado com favoritos (com fade-in + fontes)
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          itemCount: favoritos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final produtoId = favoritos[index];
            final produto = Get.find<ProductController>().getProdutoById(produtoId);

            if (produto == null) {
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text('Produto ID: $produtoId não encontrado'),
              );
            }

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Card(
                elevation: 8,
                shadowColor: theme.primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Futuramente você pode abrir a ProductDetailPage aqui
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              produto.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  produto.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  currencyFormat.format(produto.price),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: theme.primaryColor),
                            onPressed: () {
                              favoritosController.toggleFavorito(produtoId);

                              Get.snackbar(
                                'Removido',
                                '${produto.title} removido dos favoritos.',
                                colorText: Colors.white,
                                backgroundColor: theme.primaryColor,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                                icon: const Icon(Icons.favorite_border, color: Colors.white),
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
