import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<Either<Failure, Order>> call(String orderId, String reason) {
    return repository.cancelOrder(orderId, reason);
  }
}
