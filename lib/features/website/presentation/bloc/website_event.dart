import 'package:equatable/equatable.dart';

abstract class WebsiteEvent extends Equatable {
  const WebsiteEvent();

  @override
  List<Object> get props => [];
}

class GetFeaturedProductsEvent extends WebsiteEvent {}

class SubmitQuoteEvent extends WebsiteEvent {
  final Map<String, dynamic> quoteData;

  const SubmitQuoteEvent(this.quoteData);

  @override
  List<Object> get props => [quoteData];
}
