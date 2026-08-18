import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../entities/payment_status.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<Order>>> call({
    int page = 1,
    int pageSize = 10,
    String? query,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? sortBy,
    bool descending = true,
  }) {
    return repository.getOrders(
      page: page,
      pageSize: pageSize,
      query: query,
      status: status,
      paymentStatus: paymentStatus,
      sortBy: sortBy,
      descending: descending,
    );
  }
}
