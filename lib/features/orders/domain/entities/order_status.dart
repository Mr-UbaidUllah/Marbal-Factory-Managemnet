enum OrderStatus {
  pending,
  confirmed,
  processing,
  ready,
  completed,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool canTransitionTo(OrderStatus nextStatus) {
    switch (this) {
      case OrderStatus.pending:
        return [OrderStatus.confirmed, OrderStatus.cancelled].contains(nextStatus);
      case OrderStatus.confirmed:
        return [OrderStatus.processing, OrderStatus.cancelled].contains(nextStatus);
      case OrderStatus.processing:
        return [OrderStatus.ready, OrderStatus.cancelled].contains(nextStatus);
      case OrderStatus.ready:
        return [OrderStatus.completed].contains(nextStatus);
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return false;
    }
  }
}
