import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status_history.dart';

enum OrderStatusState { initial, loading, loaded, failure, submitting, success }

class OrderState extends Equatable {
  final OrderStatusState status;
  final List<Order> orders;
  final Order? selectedOrder;
  final List<OrderStatusHistory> history;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const OrderState({
    this.status = OrderStatusState.initial,
    this.orders = const [],
    this.selectedOrder,
    this.history = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  OrderState copyWith({
    OrderStatusState? status,
    List<Order>? orders,
    Order? selectedOrder,
    List<OrderStatusHistory>? history,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        selectedOrder,
        history,
        errorMessage,
        currentPage,
        hasReachedMax,
      ];
}
