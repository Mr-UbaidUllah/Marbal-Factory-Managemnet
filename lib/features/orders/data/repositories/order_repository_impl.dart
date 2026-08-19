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

  OrderRepositoryImpl({required this.quoteRepository}) {
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    
    // Order 1: Pending (from Carrara Marble quote)
    final order1Id = 'ord-1';
    _mockOrders.add(Order(
      id: order1Id,
      orderNumber: 'AMGF-ORD-2024-1001',
      quoteId: 'q-101',
      quoteNumber: 'AMGF-Q-2024-0001',
      customerName: 'John Doe',
      customerPhone: '+966 50 123 4567',
      customerEmail: 'john@example.com',
      items: [
        OrderItem(
          id: 'oi-1',
          orderId: order1Id,
          productId: 'p1',
          productName: 'Italian Carrara Marble',
          sku: 'MAR-ITA-001',
          categoryId: 'cat1',
          categoryName: 'Marble',
          quantity: 50,
          unit: 'sqm',
          unitPrice: 450,
          notes: 'High quality finish required',
        ),
      ],
      status: OrderStatus.pending,
      subtotal: 22500,
      discount: 500,
      tax: 3300,
      deliveryCharges: 250,
      total: 25550,
      paymentStatus: PaymentStatus.pending,
      paymentMethod: PaymentMethod.bankTransfer,
      deliveryAddress: 'Riyadh, Industrial Area',
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now.subtract(const Duration(days: 2)),
    ));
    _recordHistory(order1Id, null, OrderStatus.pending, 'Order created from quote');

    // Order 2: Processing (from Black Galaxy Granite quote)
    final order2Id = 'ord-2';
    _mockOrders.add(Order(
      id: order2Id,
      orderNumber: 'AMGF-ORD-2024-1002',
      quoteId: 'q-102',
      quoteNumber: 'AMGF-Q-2024-0002',
      customerName: 'Jane Smith',
      customerPhone: '+966 55 987 6543',
      items: [
        OrderItem(
          id: 'oi-2',
          orderId: order2Id,
          productId: 'p2',
          productName: 'Black Galaxy Granite',
          sku: 'GRA-IND-002',
          categoryId: 'cat2',
          categoryName: 'Granite',
          quantity: 30,
          unit: 'sqm',
          unitPrice: 280,
        ),
      ],
      status: OrderStatus.processing,
      subtotal: 8400,
      discount: 0,
      tax: 1260,
      deliveryCharges: 150,
      total: 9810,
      paymentStatus: PaymentStatus.partial,
      paymentMethod: PaymentMethod.cash,
      paymentReference: 'CASH-8821',
      deliveryAddress: 'Dammam, King Fahd Road',
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 1)),
      confirmedAt: now.subtract(const Duration(days: 4)),
      processingAt: now.subtract(const Duration(days: 1)),
    ));
    _recordHistory(order2Id, null, OrderStatus.pending, 'Order created');
    _recordHistory(order2Id, OrderStatus.pending, OrderStatus.confirmed, 'Confirmed by customer');
    _recordHistory(order2Id, OrderStatus.confirmed, OrderStatus.processing, 'Cutting started');

    // Order 3: Completed
    final order3Id = 'ord-3';
    _mockOrders.add(Order(
      id: order3Id,
      orderNumber: 'AMGF-ORD-2024-0998',
      quoteId: 'q-098',
      quoteNumber: 'AMGF-Q-2024-0098',
      customerName: 'Ahmed Ali',
      customerPhone: '+966 59 111 2222',
      items: [
        OrderItem(
          id: 'oi-3',
          orderId: order3Id,
          productId: 'p3',
          productName: 'Volakas White Marble',
          sku: 'MAR-GRE-003',
          categoryId: 'cat1',
          categoryName: 'Marble',
          quantity: 10,
          unit: 'sqm',
          unitPrice: 600,
        ),
      ],
      status: OrderStatus.completed,
      subtotal: 6000,
      discount: 200,
      tax: 870,
      deliveryCharges: 100,
      total: 6770,
      paymentStatus: PaymentStatus.paid,
      paymentMethod: PaymentMethod.card,
      paymentReference: 'TXN-998273',
      deliveryAddress: 'Jeddah, Al Hamra',
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(days: 15)),
      confirmedAt: now.subtract(const Duration(days: 19)),
      processingAt: now.subtract(const Duration(days: 18)),
      readyAt: now.subtract(const Duration(days: 16)),
      completedAt: now.subtract(const Duration(days: 15)),
    ));
    _recordHistory(order3Id, null, OrderStatus.pending, 'Initial creation');
    _recordHistory(order3Id, OrderStatus.pending, OrderStatus.confirmed, null);
    _recordHistory(order3Id, OrderStatus.confirmed, OrderStatus.processing, null);
    _recordHistory(order3Id, OrderStatus.processing, OrderStatus.ready, 'Quality check passed');
    _recordHistory(order3Id, OrderStatus.ready, OrderStatus.completed, 'Delivered and signed');
  }

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
      previousStatus: previousStatus ?? newStatus, 
      newStatus: newStatus,
      note: note,
      changedBy: 'Admin',
      createdAt: DateTime.now(),
    ));
  }
}
