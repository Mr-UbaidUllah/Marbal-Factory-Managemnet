import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/change_order_status.dart';
import '../../domain/usecases/create_order_from_quote.dart';
import '../../domain/usecases/get_order.dart';
import '../../domain/usecases/get_order_status_history.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/update_order.dart';
import '../../domain/usecases/update_payment.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrders getOrders;
  final GetOrder getOrder;
  final CreateOrderFromQuote createOrderFromQuote;
  final UpdateOrder updateOrder;
  final ChangeOrderStatus changeOrderStatus;
  final UpdatePayment updatePayment;
  final CancelOrder cancelOrder;
  final GetOrderStatusHistory getOrderStatusHistory;

  OrderBloc({
    required this.getOrders,
    required this.getOrder,
    required this.createOrderFromQuote,
    required this.updateOrder,
    required this.changeOrderStatus,
    required this.updatePayment,
    required this.cancelOrder,
    required this.getOrderStatusHistory,
  }) : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<GetOrderDetail>(_onGetOrderDetail);
    on<CreateOrderFromQuoteEvent>(_onCreateOrderFromQuote);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<ChangeOrderStatusEvent>(_onChangeOrderStatus);
    on<UpdateOrderPaymentEvent>(_onUpdateOrderPayment);
    on<CancelOrderEvent>(_onCancelOrder);
    on<LoadOrderStatusHistoryEvent>(_onLoadOrderStatusHistory);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.loading));
    
    final result = await getOrders(
      page: event.page,
      query: event.query,
      status: event.status,
      paymentStatus: event.paymentStatus,
      sortBy: event.sortBy,
      descending: event.descending,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (orders) => emit(state.copyWith(
        status: OrderStatusState.loaded,
        orders: orders,
        currentPage: event.page,
      )),
    );
  }

  Future<void> _onGetOrderDetail(GetOrderDetail event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.loading));
    final result = await getOrder(event.id);
    
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) async {
        emit(state.copyWith(
          status: OrderStatusState.loaded,
          selectedOrder: order,
        ));
        add(LoadOrderStatusHistoryEvent(order.id));
      },
    );
  }

  Future<void> _onCreateOrderFromQuote(CreateOrderFromQuoteEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.submitting));
    final result = await createOrderFromQuote(event.quoteId);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) => emit(state.copyWith(
        status: OrderStatusState.success,
        selectedOrder: order,
      )),
    );
  }

  Future<void> _onUpdateOrder(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.submitting));
    final result = await updateOrder(event.order);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) => emit(state.copyWith(
        status: OrderStatusState.success,
        selectedOrder: order,
      )),
    );
  }

  Future<void> _onChangeOrderStatus(ChangeOrderStatusEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.submitting));
    final result = await changeOrderStatus(
      event.orderId,
      event.newStatus,
      note: event.note,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) {
        emit(state.copyWith(
          status: OrderStatusState.success,
          selectedOrder: order,
        ));
        add(LoadOrderStatusHistoryEvent(order.id));
      },
    );
  }

  Future<void> _onUpdateOrderPayment(UpdateOrderPaymentEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.submitting));
    final result = await updatePayment(
      event.orderId,
      paymentStatus: event.paymentStatus,
      paymentMethod: event.paymentMethod,
      reference: event.reference,
      notes: event.notes,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) => emit(state.copyWith(
        status: OrderStatusState.success,
        selectedOrder: order,
      )),
    );
  }

  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatusState.submitting));
    final result = await cancelOrder(event.orderId, event.reason);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderStatusState.failure,
        errorMessage: failure.message,
      )),
      (order) {
        emit(state.copyWith(
          status: OrderStatusState.success,
          selectedOrder: order,
        ));
        add(LoadOrderStatusHistoryEvent(order.id));
      },
    );
  }

  Future<void> _onLoadOrderStatusHistory(LoadOrderStatusHistoryEvent event, Emitter<OrderState> emit) async {
    final result = await getOrderStatusHistory(event.orderId);
    
    result.fold(
      (failure) => null, // Silently fail history load or handle as needed
      (history) => emit(state.copyWith(history: history)),
    );
  }
}
