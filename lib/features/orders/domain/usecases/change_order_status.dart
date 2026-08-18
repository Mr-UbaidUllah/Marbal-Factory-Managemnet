import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repositories/order_repository.dart';

class ChangeOrderStatus {
  final OrderRepository repository;

  ChangeOrderStatus(this.repository);

  Future<Either<Failure, Order>> call(
    String orderId,
    OrderStatus newStatus, {
    String? note,
  }) {
    return repository.changeOrderStatus(orderId, newStatus, note: note);
  }
}
