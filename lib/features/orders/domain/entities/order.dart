import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'payment_status.dart';
import 'payment_method.dart';

class Order extends Equatable {
  final String id;
  final String orderNumber;
  final String quoteId;
  final String quoteNumber;
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryCharges;
  final double total;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final String? paymentReference;
  final String? paymentNotes;
  final String deliveryAddress;
  final String? deliveryNotes;
  final String? orderNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? processingAt;
  final DateTime? readyAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.quoteId,
    required this.quoteNumber,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryCharges,
    required this.total,
    required this.paymentStatus,
    required this.paymentMethod,
    this.paymentReference,
    this.paymentNotes,
    required this.deliveryAddress,
    this.deliveryNotes,
    this.orderNotes,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
    this.processingAt,
    this.readyAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        quoteId,
        quoteNumber,
        customerName,
        customerPhone,
        customerEmail,
        items,
        status,
        subtotal,
        discount,
        tax,
        deliveryCharges,
        total,
        paymentStatus,
        paymentMethod,
        paymentReference,
        paymentNotes,
        deliveryAddress,
        deliveryNotes,
        orderNotes,
        createdAt,
        updatedAt,
        confirmedAt,
        processingAt,
        readyAt,
        completedAt,
        cancelledAt,
        cancellationReason,
      ];

  Order copyWith({
    String? id,
    String? orderNumber,
    String? quoteId,
    String? quoteNumber,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<OrderItem>? items,
    OrderStatus? status,
    double? subtotal,
    double? discount,
    double? tax,
    double? deliveryCharges,
    double? total,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? paymentReference,
    String? paymentNotes,
    String? deliveryAddress,
    String? deliveryNotes,
    String? orderNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? confirmedAt,
    DateTime? processingAt,
    DateTime? readyAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      quoteId: quoteId ?? this.quoteId,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      total: total ?? this.total,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      paymentNotes: paymentNotes ?? this.paymentNotes,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      orderNotes: orderNotes ?? this.orderNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      processingAt: processingAt ?? this.processingAt,
      readyAt: readyAt ?? this.readyAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
