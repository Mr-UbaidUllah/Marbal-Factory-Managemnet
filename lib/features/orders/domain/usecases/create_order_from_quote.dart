import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderFromQuote {
  final OrderRepository repository;

  CreateOrderFromQuote(this.repository);

  Future<Either<Failure, Order>> call(String quoteId) {
    return repository.createOrderFromQuote(quoteId);
  }
}
