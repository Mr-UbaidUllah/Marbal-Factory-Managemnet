import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';
import 'order_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.quoteId,
    required super.quoteNumber,
    required super.customerName,
    required super.customerPhone,
    super.customerEmail,
    required super.items,
    required super.status,
    required super.subtotal,
    required super.discount,
    required super.tax,
    required super.deliveryCharges,
    required super.total,
    required super.paymentStatus,
    required super.paymentMethod,
    super.paymentReference,
    super.paymentNotes,
    required super.deliveryAddress,
    super.deliveryNotes,
    super.orderNotes,
    required super.createdAt,
    required super.updatedAt,
    super.confirmedAt,
    super.processingAt,
    super.readyAt,
    super.completedAt,
    super.cancelledAt,
    super.cancellationReason,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      quoteId: json['quoteId'] as String,
      quoteNumber: json['quoteNumber'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String?,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
        orElse: () => OrderStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryCharges: (json['deliveryCharges'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['paymentStatus'] as String).toLowerCase(),
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['paymentMethod'] as String).toLowerCase(),
        orElse: () => PaymentMethod.cash,
      ),
      paymentReference: json['paymentReference'] as String?,
      paymentNotes: json['paymentNotes'] as String?,
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryNotes: json['deliveryNotes'] as String?,
      orderNotes: json['orderNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt'] as String) : null,
      processingAt: json['processingAt'] != null ? DateTime.parse(json['processingAt'] as String) : null,
      readyAt: json['readyAt'] != null ? DateTime.parse(json['readyAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      cancellationReason: json['cancellationReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'quoteId': quoteId,
      'quoteNumber': quoteNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items.map((item) => OrderItemModel.fromEntity(item).toJson()).toList(),
      'status': status.name.toLowerCase(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'deliveryCharges': deliveryCharges,
      'total': total,
      'paymentStatus': paymentStatus.name.toLowerCase(),
      'paymentMethod': paymentMethod.name.toLowerCase(),
      'paymentReference': paymentReference,
      'paymentNotes': paymentNotes,
      'deliveryAddress': deliveryAddress,
      'deliveryNotes': deliveryNotes,
      'orderNotes': orderNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'processingAt': processingAt?.toIso8601String(),
      'readyAt': readyAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      quoteId: entity.quoteId,
      quoteNumber: entity.quoteNumber,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      customerEmail: entity.customerEmail,
      items: entity.items,
      status: entity.status,
      subtotal: entity.subtotal,
      discount: entity.discount,
      tax: entity.tax,
      deliveryCharges: entity.deliveryCharges,
      total: entity.total,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      paymentReference: entity.paymentReference,
      paymentNotes: entity.paymentNotes,
      deliveryAddress: entity.deliveryAddress,
      deliveryNotes: entity.deliveryNotes,
      orderNotes: entity.orderNotes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      confirmedAt: entity.confirmedAt,
      processingAt: entity.processingAt,
      readyAt: entity.readyAt,
      completedAt: entity.completedAt,
      cancelledAt: entity.cancelledAt,
      cancellationReason: entity.cancellationReason,
    );
  }
}
