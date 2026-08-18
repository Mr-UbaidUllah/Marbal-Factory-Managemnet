import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../entities/payment_method.dart';
import '../entities/payment_status.dart';
import '../repositories/order_repository.dart';

class UpdatePayment {
  final OrderRepository repository;

  UpdatePayment(this.repository);

  Future<Either<Failure, Order>> call(
    String orderId, {
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    String? reference,
    String? notes,
  }) {
    return repository.updatePayment(
      orderId,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      reference: reference,
      notes: notes,
    );
  }
}
