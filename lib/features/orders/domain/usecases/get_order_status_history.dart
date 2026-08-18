import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_status_history.dart';
import '../repositories/order_repository.dart';

class GetOrderStatusHistory {
  final OrderRepository repository;

  GetOrderStatusHistory(this.repository);

  Future<Either<Failure, List<OrderStatusHistory>>> call(String orderId) {
    return repository.getOrderStatusHistory(orderId);
  }
}
