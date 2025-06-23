import 'package:flutter/material.dart';
import '../models/models.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(status);
    // ignore: deprecated_member_use
    final Color bgColor = statusColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Mesma função que você tinha
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.concluido:
        return Colors.green;
      case OrderStatus.emAndamento:
        return Colors.orange;
      case OrderStatus.cancelado:
        return Colors.red;
      // ignore: unreachable_switch_default
      default:
        return Colors.blueGrey;
    }
  }
}
