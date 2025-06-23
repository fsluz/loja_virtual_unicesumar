import 'package:flutter/material.dart';//para usar widgets

enum OrderStatus {
  concluido,
  emAndamento,
  cancelado,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.concluido:
        return 'Concluído';
      case OrderStatus.emAndamento:
        return 'Em andamento';
      case OrderStatus.cancelado:
        return 'Cancelado';
    }
  }
//Adição de cor para cada status
  Color get color {//
    switch (this) {
      case OrderStatus.concluido:
        return Colors.green;
      case OrderStatus.emAndamento:
        return Colors.blue;
      case OrderStatus.cancelado:
        return Colors.red;
    }
  }//
//Verificação de cancelamento
  bool get podeCancelar {
    return this == OrderStatus.emAndamento;
  }

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'concluído':
      case 'concluido':
        return OrderStatus.concluido;
      case 'em andamento':
        return OrderStatus.emAndamento;
      case 'cancelado':
        return OrderStatus.cancelado;
      default:
        return OrderStatus.emAndamento;
    }
  }
}
