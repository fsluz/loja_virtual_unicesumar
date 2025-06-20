import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import './../../controllers/controllers.dart';
import './../../widgets/widgets.dart';
import './../../models/models.dart';
import './order_detail_page.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  final OrderController _orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final DateFormat dateTimeFormat = DateFormat('dd/MM/yy \'às\' HH:mm', 'pt_BR');
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        final pedidos = _orderController.orderList;

        if (pedidos.isEmpty) {
          // Nenhum pedido
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 120,
                    color: theme.primaryColor.withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nenhum pedido encontrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Você ainda não realizou nenhuma compra.\nAproveite nossas ofertas!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }

        // Lista de pedidos estilo mais moderno com status dinâmico
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: pedidos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final OrderModel pedido = pedidos[index];

            final data = pedido.date;
            final total = pedido.products.fold<double>(
              0.0,
              (sum, item) => sum + (item.quantity * item.price),
            );

            // Itens resumo
            final int totalItens = pedido.products.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.to(() => OrderDetailPage(order: pedido));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ícone ou imagem simulada
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_bag_outlined, color: theme.primaryColor),
                      ),
                      const SizedBox(width: 12),

                      // Infos do pedido
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pedido #${pedido.id}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dateTimeFormat.format(data)} • ${totalItens.toString().padLeft(2, '0')} itens',
                              style: TextStyle(
                                  fontSize: 12, color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: ${currencyFormat.format(total)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status badge + seta
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          OrderStatusBadge(status: pedido.status),
                          const SizedBox(height: 8),
                          Icon(Icons.arrow_forward_ios, size: 16, color: theme.textTheme.bodySmall?.color),
                        ],
                      ),
                    ],
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
