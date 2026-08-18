import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';
import 'quote_item_model.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.quoteNumber,
    required super.requesterName,
    required super.requesterPhone,
    super.requesterEmail,
    super.requesterAddress,
    required super.status,
    required super.items,
    required super.subtotal,
    required super.discount,
    required super.tax,
    required super.deliveryCharges,
    required super.total,
    super.customerNotes,
    super.adminNotes,
    super.validUntil,
    required super.createdAt,
    required super.updatedAt,
    super.respondedAt,
    super.acceptedAt,
    super.rejectedAt,
    super.rejectionReason,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      quoteNumber: json['quoteNumber'] as String,
      requesterName: json['requesterName'] as String,
      requesterPhone: json['requesterPhone'] as String,
      requesterEmail: json['requesterEmail'] as String?,
      requesterAddress: json['requesterAddress'] as String?,
      status: QuoteStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
        orElse: () => QuoteStatus.pending,
      ),
      items: (json['items'] as List)
          .map((item) => QuoteItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryCharges: (json['deliveryCharges'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      customerNotes: json['customerNotes'] as String?,
      adminNotes: json['adminNotes'] as String?,
      validUntil: json['validUntil'] != null ? DateTime.parse(json['validUntil'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      respondedAt: json['respondedAt'] != null ? DateTime.parse(json['respondedAt'] as String) : null,
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt'] as String) : null,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quoteNumber': quoteNumber,
      'requesterName': requesterName,
      'requesterPhone': requesterPhone,
      'requesterEmail': requesterEmail,
      'requesterAddress': requesterAddress,
      'status': status.name,
      'items': items.map((item) => QuoteItemModel.fromEntity(item).toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'deliveryCharges': deliveryCharges,
      'total': total,
      'customerNotes': customerNotes,
      'adminNotes': adminNotes,
      'validUntil': validUntil?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }

  factory QuoteModel.fromEntity(Quote quote) {
    return QuoteModel(
      id: quote.id,
      quoteNumber: quote.quoteNumber,
      requesterName: quote.requesterName,
      requesterPhone: quote.requesterPhone,
      requesterEmail: quote.requesterEmail,
      requesterAddress: quote.requesterAddress,
      status: quote.status,
      items: quote.items,
      subtotal: quote.subtotal,
      discount: quote.discount,
      tax: quote.tax,
      deliveryCharges: quote.deliveryCharges,
      total: quote.total,
      customerNotes: quote.customerNotes,
      adminNotes: quote.adminNotes,
      validUntil: quote.validUntil,
      createdAt: quote.createdAt,
      updatedAt: quote.updatedAt,
      respondedAt: quote.respondedAt,
      acceptedAt: quote.acceptedAt,
      rejectedAt: quote.rejectedAt,
      rejectionReason: quote.rejectionReason,
    );
  }
}
