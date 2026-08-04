import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/website/domain/usecases/get_featured_products_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/submit_quote_usecase.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';

class WebsiteBloc extends Bloc<WebsiteEvent, WebsiteState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final SubmitQuoteUseCase submitQuoteUseCase;

  WebsiteBloc({
    required this.getFeaturedProductsUseCase,
    required this.submitQuoteUseCase,
  }) : super(const WebsiteState()) {
    on<GetFeaturedProductsEvent>(_onGetFeaturedProducts);
    on<SubmitQuoteEvent>(_onSubmitQuote);
  }

  Future<void> _onGetFeaturedProducts(
    GetFeaturedProductsEvent event,
    Emitter<WebsiteState> emit,
  ) async {
    emit(state.copyWith(status: WebsiteStatus.loading));
    final result = await getFeaturedProductsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: WebsiteStatus.failure,
        failure: failure,
      )),
      (products) => emit(state.copyWith(
        status: WebsiteStatus.success,
        featuredProducts: products,
      )),
    );
  }

  Future<void> _onSubmitQuote(
    SubmitQuoteEvent event,
    Emitter<WebsiteState> emit,
  ) async {
    emit(state.copyWith(isQuoteSubmitting: true, isQuoteSuccess: false));
    final result = await submitQuoteUseCase(event.quoteData);
    result.fold(
      (failure) => emit(state.copyWith(
        isQuoteSubmitting: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isQuoteSubmitting: false,
        isQuoteSuccess: true,
      )),
    );
  }
}
