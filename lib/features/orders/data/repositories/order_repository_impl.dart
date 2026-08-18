import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../../../quotations/domain/entities/quote.dart';
import '../../../quotations/domain/entities/quote_status.dart';
import '../../../quotations/domain/repositories/quote_repository.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_status_history.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final QuoteRepository quoteRepository;
  final List<Order> _mockOrders = [];
  final List<OrderStatusHistory> _mockHistory = [];

  OrderRepositoryImpl({required this.quoteRepository});

  @override
  Future<Either<Failure, List<Order>>> getOrders({
    int page = 1,
    int pageSize = 10,
    String? query,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? sortBy,
    bool descending = true,
  }) async {
    try {
      var filtered = _mockOrders.where((o) {
        if (query != null && query.isNotEmpty) {
          final ql = query.toLowerCase();
          if (!o.orderNumber.toLowerCase().contains(ql) &&
              !o.quoteNumber.toLowerCase().contains(ql) &&
              !o.customerName.toLowerCase().contains(ql) &&
              !o.items.any((item) => item.productName.toLowerCase().contains(ql) || item.sku.toLowerCase().contains(ql))) {
            return false;
          }
        }
        if (status != null && o.status != status) return false;
        if (paymentStatus != null && o.paymentStatus != paymentStatus) return false;
        return true;
      }).toList();

      // Simple sorting
      if (sortBy == 'total') {
        filtered.sort((a, b) => a.total.compareTo(b.total));
      } else if (sortBy == 'orderNumber') {
        filtered.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
      } else {
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      if (descending) {
        filtered = filtered.reversed.toList();
      }

      final start = (page - 1) * pageSize;
      final end = start + pageSize;
      final paginated = filtered.sublist(
        start.clamp(0, filtered.length),
        end.clamp(0, filtered.length),
      );

      return Right(paginated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String id) async {
    try {
      final order = _mockOrders.firstWhere((o) => o.id == id);
      return Right(order);
    } catch (e) {
      return const Left(ServerFailure('Order not found'));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrderFromQuote(String quoteId) async {
    try {
      // 1. Load the quotation
      final quoteResult = await quoteRepository.getQuoteById(quoteId);
      
      return await quoteResult.fold(
        (failure) async => Left(failure),
        (quote) async {
          // 2. Verify quotation status is Accepted
          if (quote.status != QuoteStatus.accepted) {
            return const Left(ValidationFailure('Only accepted quotations can be converted to orders.'));
          }

          // 3. Verify quotation has not already been converted
          final exists = _mockOrders.any((o) => o.quoteId == quoteId);
          if (exists) {
            return const Left(ValidationFailure('An order has already been created for this quotation.'));
          }

          // 4-14. Map Quote to Order
          final orderId = DateTime.now().millisecondsSinceEpoch.toString();
          final orderNumber = 'AMGF-ORD-${DateTime.now().year}-${_mockOrders.length + 1001}';
          
          final orderItems = quote.items.map((qi) => OrderItem(
            id: DateTime.now().millisecondsSinceEpoch.toString() + qi.id,
            orderId: orderId,
            productId: qi.productId,
            productName: qi.productName,
            sku: qi.sku,
            categoryId: qi.categoryId,
            categoryName: qi.categoryName,
            quantity: qi.quantity,
            unit: qi.unit,
            unitPrice: qi.quotedPrice,
            discount: qi.discount,
            notes: qi.notes,
          )).toList();

          final newOrder = Order(
            id: orderId,
            orderNumber: orderNumber,
            quoteId: quote.id,
            quoteNumber: quote.quoteNumber,
            customerName: quote.requesterName,
            customerPhone: quote.requesterPhone,
            customerEmail: quote.requesterEmail,
            items: orderItems,
            status: OrderStatus.pending,
            subtotal: quote.subtotal,
            discount: quote.discount,
            tax: quote.tax,
            deliveryCharges: quote.deliveryCharges,
            total: quote.total,
            paymentStatus: PaymentStatus.pending,
            paymentMethod: PaymentMethod.cash, // Default
            deliveryAddress: quote.requesterAddress ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // 15. Save the Order
          _mockOrders.add(newOrder);

          // 17. Record History
          _recordHistory(orderId, null, OrderStatus.pending, 'Order created from quotation ${quote.quoteNumber}');

          return Right(newOrder);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrder(Order order) async {
    try {
      final index = _mockOrders.indexWhere((o) => o.id == order.id);
      if (index == -1) return const Left(ServerFailure('Order not found'));

      final current = _mockOrders[index];

      // Business Rules: Completed/Cancelled cannot be edited
      if (current.status == OrderStatus.completed || current.status == OrderStatus.cancelled) {
        return const Left(ValidationFailure('Completed or cancelled orders cannot be edited.'));
      }

      // Implement editing restrictions based on status as per PHASE 19
      // For now, allow general update as the UI will handle specific field access
      
      final updated = OrderModel.fromEntity(order).copyWith(updatedAt: DateTime.now());
      _mockOrders[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> changeOrderStatus(
    String orderId,
    OrderStatus newStatus, {
    String? note,
  }) async {
    try {
      final index = _mockOrders.indexWhere((o) => o.id == orderId);
      if (index == -1) return const Left(ServerFailure('Order not found'));

      final current = _mockOrders[index];

      if (!current.status.canTransitionTo(newStatus)) {
        return const Left(ValidationFailure('Invalid status transition.'));
      }

      Order updated = OrderModel.fromEntity(current).copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      // Set timestamp based on status
      switch (newStatus) {
        case OrderStatus.confirmed:
          updated = updated.copyWith(confirmedAt: DateTime.now());
          break;
        case OrderStatus.processing:
          updated = updated.copyWith(processingAt: DateTime.now());
          break;
        case OrderStatus.ready:
          updated = updated.copyWith(readyAt: DateTime.now());
          break;
        case OrderStatus.completed:
          updated = updated.copyWith(completedAt: DateTime.now());
          break;
        case OrderStatus.cancelled:
          updated = updated.copyWith(cancelledAt: DateTime.now());
          break;
        default:
          break;
      }

      _mockOrders[index] = updated;
      _recordHistory(orderId, current.status, newStatus, note);

      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updatePayment(
    String orderId, {
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    String? reference,
    String? notes,
  }) async {
    try {
      final index = _mockOrders.indexWhere((o) => o.id == orderId);
      if (index == -1) return const Left(ServerFailure('Order not found'));

      final current = _mockOrders[index];
      
      final updated = OrderModel.fromEntity(current).copyWith(
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        paymentReference: reference,
        paymentNotes: notes,
        updatedAt: DateTime.now(),
      );

      _mockOrders[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> cancelOrder(
    String orderId,
    String reason,
  ) async {
    return changeOrderStatus(orderId, OrderStatus.cancelled, note: reason);
  }

  @override
  Future<Either<Failure, List<OrderStatusHistory>>> getOrderStatusHistory(String orderId) async {
    try {
      final history = _mockHistory.where((h) => h.orderId == orderId).toList();
      history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(history);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _recordHistory(String orderId, OrderStatus? previousStatus, OrderStatus newStatus, String? note) {
    _mockHistory.add(OrderStatusHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: orderId,
      previousStatus: previousStatus ?? newStatus, // For initial creation, use same status or a dummy
      newStatus: newStatus,
      note: note,
      changedBy: 'Admin', // In real app, get from auth
      createdAt: DateTime.now(),
    ));
  }
}
