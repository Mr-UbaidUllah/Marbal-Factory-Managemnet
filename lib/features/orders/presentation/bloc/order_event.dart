import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  final bool refresh;
  final String? query;
  final OrderStatus? status;
  final PaymentStatus? paymentStatus;
  final String? sortBy;
  final bool descending;
  final int page;

  const LoadOrders({
    this.refresh = false,
    this.query,
    this.status,
    this.paymentStatus,
    this.sortBy,
    this.descending = true,
    this.page = 1,
  });

  @override
  List<Object?> get props => [refresh, query, status, paymentStatus, sortBy, descending, page];
}

class GetOrderDetail extends OrderEvent {
  final String id;
  const GetOrderDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateOrderFromQuoteEvent extends OrderEvent {
  final String quoteId;
  const CreateOrderFromQuoteEvent(this.quoteId);

  @override
  List<Object?> get props => [quoteId];
}

class UpdateOrderEvent extends OrderEvent {
  final Order order;
  const UpdateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class ChangeOrderStatusEvent extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;
  final String? note;

  const ChangeOrderStatusEvent(this.orderId, this.newStatus, {this.note});

  @override
  List<Object?> get props => [orderId, newStatus, note];
}

class UpdateOrderPaymentEvent extends OrderEvent {
  final String orderId;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final String? reference;
  final String? notes;

  const UpdateOrderPaymentEvent({
    required this.orderId,
    required this.paymentStatus,
    required this.paymentMethod,
    this.reference,
    this.notes,
  });

  @override
  List<Object?> get props => [orderId, paymentStatus, paymentMethod, reference, notes];
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;
  final String reason;

  const CancelOrderEvent(this.orderId, this.reason);

  @override
  List<Object?> get props => [orderId, reason];
}

class LoadOrderStatusHistoryEvent extends OrderEvent {
  final String orderId;
  const LoadOrderStatusHistoryEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
