import 'package:equatable/equatable.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';

enum WebsiteStatus { initial, loading, success, failure }

class WebsiteState extends Equatable {
  final WebsiteStatus status;
  final List<Product> featuredProducts;
  final Failure? failure;
  final bool isQuoteSubmitting;
  final bool isQuoteSuccess;

  const WebsiteState({
    this.status = WebsiteStatus.initial,
    this.featuredProducts = const [],
    this.failure,
    this.isQuoteSubmitting = false,
    this.isQuoteSuccess = false,
  });

  WebsiteState copyWith({
    WebsiteStatus? status,
    List<Product>? featuredProducts,
    Failure? failure,
    bool? isQuoteSubmitting,
    bool? isQuoteSuccess,
  }) {
    return WebsiteState(
      status: status ?? this.status,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      failure: failure ?? this.failure,
      isQuoteSubmitting: isQuoteSubmitting ?? this.isQuoteSubmitting,
      isQuoteSuccess: isQuoteSuccess ?? this.isQuoteSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        featuredProducts,
        failure,
        isQuoteSubmitting,
        isQuoteSuccess,
      ];
}
