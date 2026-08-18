import 'package:equatable/equatable.dart';
import 'order_status.dart';

class OrderStatusHistory extends Equatable {
  final String id;
  final String orderId;
  final OrderStatus previousStatus;
  final OrderStatus newStatus;
  final String? note;
  final String changedBy;
  final DateTime createdAt;

  const OrderStatusHistory({
    required this.id,
    required this.orderId,
    required this.previousStatus,
    required this.newStatus,
    this.note,
    required this.changedBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        previousStatus,
        newStatus,
        note,
        changedBy,
        createdAt,
      ];
}
