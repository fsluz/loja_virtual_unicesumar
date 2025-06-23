import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import './../../controllers/controllers.dart';
import './../../models/models.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final CartController cartController = Get.find<CartController>();
  final FavoritosController favoritosController = Get.find<FavoritosController>();
  final AuthController authController = Get.find<AuthController>();

  bool get isLogado => authController.logado.value;

  int quantidade = 1; // Stepper

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        actions: [
          /// Favoritar no AppBar
          Obx(() {
            final isFavorito = favoritosController.isFavorito(widget.product.id);
            return IconButton(
              icon: Icon(
                isFavorito ? Icons.favorite : Icons.favorite_border,
                color: isFavorito ? Colors.red : Colors.white,
              ),
              onPressed: () {
                if (!isLogado) {
                  Get.snackbar(
                    'Acesso negado',
                    'Faça login para favoritar produtos.',
                    colorText: Colors.white,
                    backgroundColor: theme.primaryColor,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    icon: const Icon(Icons.lock_outline, color: Colors.white),
                    duration: const Duration(seconds: 3),
                  );
                  return;
                }
                favoritosController.toggleFavorito(widget.product.id);
              },
            );
          }),
        ],
      ),

      body: Column(
        children: [
          /// Imagem grande
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: AspectRatio(
              aspectRatio: 1.2, // bom para tela de detalhe
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: widget.product.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ),

          /// Conteúdo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Nome
                    Text(
                      widget.product.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),

                    /// Row com Preço + Quantidade
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Preço
                        Text(
                          currencyFormat.format(widget.product.price * quantidade),
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        /// Quantidade (Stepper)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: theme.iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (quantidade > 1) {
                                    quantidade--;
                                  }
                                });
                              },
                            ),
                            Text(
                              quantidade.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: theme.iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  quantidade++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Descrição
                    Text(
                      'Descrição:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      /// Botão "Adicionar ao Carrinho" fixo na parte inferior
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Adicionar ao Carrinho'),
              onPressed: () async {
                await cartController.addProductToCart(
                  widget.product,
                  quantidade,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
