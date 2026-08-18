import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../entities/order_status_history.dart';
import '../entities/payment_status.dart';
import '../entities/payment_method.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders({
    int page = 1,
    int pageSize = 10,
    String? query,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? sortBy,
    bool descending = true,
  });

  Future<Either<Failure, Order>> getOrderById(String id);

  Future<Either<Failure, Order>> createOrderFromQuote(String quoteId);

  Future<Either<Failure, Order>> updateOrder(Order order);

  Future<Either<Failure, Order>> changeOrderStatus(
    String orderId,
    OrderStatus newStatus, {
    String? note,
  });

  Future<Either<Failure, Order>> updatePayment(
    String orderId, {
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    String? reference,
    String? notes,
  });

  Future<Either<Failure, Order>> cancelOrder(
    String orderId,
    String reason,
  );

  Future<Either<Failure, List<OrderStatusHistory>>> getOrderStatusHistory(String orderId);
}
