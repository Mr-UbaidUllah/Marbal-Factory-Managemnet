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

class GetProjectsEvent extends WebsiteEvent {}

class GetProjectDetailsEvent extends WebsiteEvent {
  final String projectId;

  const GetProjectDetailsEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}
