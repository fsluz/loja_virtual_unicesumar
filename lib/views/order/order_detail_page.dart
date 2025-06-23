import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/controllers.dart';
import './../../models/models.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR');

    final theme = Theme.of(context);

    // Cálculo total com preço real
    final total = order.products.fold<double>(
      0.0,
      (sum, item) => sum + (item.quantity * item.price),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: order.status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: order.status.color),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${order.status.label}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: order.status.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data do pedido: ${dateTimeFormat.format(order.date)}',
                    style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botão de cancelamento
            if (order.status.podeCancelar) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showCancelDialog(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancelar Pedido'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],//

            // Lista de produtos
            const Text(
              'Itens do pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.products.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = order.products[index];

                // Opcional: buscar nome do produto (caso exista no ProductController)
                final product = Get.find<ProductController>().getProdutoById(item.productId);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    child: Text(
                      '${item.productId}',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                  title: Text(product?.title ?? 'Produto ${item.productId}'),
                  subtitle: Text('Quantidade: ${item.quantity}'),
                  trailing: Text(
                    currencyFormat.format(item.quantity * item.price),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total do pedido:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(total),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
//Métodos para mostar dialogo
  void _showCancelDialog(BuildContext context) {//
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Pedido'),
        content: const Text('Tem certeza que deseja cancelar este pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );
  }

//Método para executar o cancelamento
  void _cancelOrder() {
  // Remove o pedido da lista
    final orderController = Get.find<OrderController>();
    orderController.deleteOrder(order.id);//
    
    // Mostra mensagem de sucesso
    Get.snackbar(
      'Pedido Cancelado',
      'O pedido #${order.id} foi cancelado e removido da lista.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
    
    // Volta para a página anterior
    Get.back();
  }
}
