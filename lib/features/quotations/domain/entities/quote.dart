import 'package:equatable/equatable.dart';
import 'quote_item.dart';
import 'quote_status.dart';

class Quote extends Equatable {
  final String id;
  final String quoteNumber;
  final String requesterName;
  final String requesterPhone;
  final String? requesterEmail;
  final String? requesterAddress;
  final QuoteStatus status;
  final List<QuoteItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryCharges;
  final double total;
  final String? customerNotes;
  final String? adminNotes;
  final DateTime? validUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? respondedAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;

  const Quote({
    required this.id,
    required this.quoteNumber,
    required this.requesterName,
    required this.requesterPhone,
    this.requesterEmail,
    this.requesterAddress,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryCharges,
    required this.total,
    this.customerNotes,
    this.adminNotes,
    this.validUntil,
    required this.createdAt,
    required this.updatedAt,
    this.respondedAt,
    this.acceptedAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [
        id,
        quoteNumber,
        requesterName,
        requesterPhone,
        requesterEmail,
        requesterAddress,
        status,
        items,
        subtotal,
        discount,
        tax,
        deliveryCharges,
        total,
        customerNotes,
        adminNotes,
        validUntil,
        createdAt,
        updatedAt,
        respondedAt,
        acceptedAt,
        rejectedAt,
        rejectionReason,
      ];

  Quote copyWith({
    String? id,
    String? quoteNumber,
    String? requesterName,
    String? requesterPhone,
    String? requesterEmail,
    String? requesterAddress,
    QuoteStatus? status,
    List<QuoteItem>? items,
    double? subtotal,
    double? discount,
    double? tax,
    double? deliveryCharges,
    double? total,
    String? customerNotes,
    String? adminNotes,
    DateTime? validUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? respondedAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    String? rejectionReason,
  }) {
    return Quote(
      id: id ?? this.id,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      requesterName: requesterName ?? this.requesterName,
      requesterPhone: requesterPhone ?? this.requesterPhone,
      requesterEmail: requesterEmail ?? this.requesterEmail,
      requesterAddress: requesterAddress ?? this.requesterAddress,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      total: total ?? this.total,
      customerNotes: customerNotes ?? this.customerNotes,
      adminNotes: adminNotes ?? this.adminNotes,
      validUntil: validUntil ?? this.validUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
