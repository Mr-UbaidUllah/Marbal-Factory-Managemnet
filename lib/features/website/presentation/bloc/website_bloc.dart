import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/website/domain/usecases/get_featured_products_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/submit_quote_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/get_projects_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/get_project_by_id_usecase.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';

class WebsiteBloc extends Bloc<WebsiteEvent, WebsiteState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final SubmitQuoteUseCase submitQuoteUseCase;
  final GetProjectsUseCase getProjectsUseCase;
  final GetProjectByIdUseCase getProjectByIdUseCase;

  WebsiteBloc({
    required this.getFeaturedProductsUseCase,
    required this.submitQuoteUseCase,
    required this.getProjectsUseCase,
    required this.getProjectByIdUseCase,
  }) : super(const WebsiteState()) {
    on<GetFeaturedProductsEvent>(_onGetFeaturedProducts);
    on<SubmitQuoteEvent>(_onSubmitQuote);
    on<GetProjectsEvent>(_onGetProjects);
    on<GetProjectDetailsEvent>(_onGetProjectDetails);
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

  Future<void> _onGetProjects(
    GetProjectsEvent event,
    Emitter<WebsiteState> emit,
  ) async {
    emit(state.copyWith(status: WebsiteStatus.loading));
    final result = await getProjectsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: WebsiteStatus.failure,
        failure: failure,
      )),
      (projects) => emit(state.copyWith(
        status: WebsiteStatus.success,
        projects: projects,
      )),
    );
  }

  Future<void> _onGetProjectDetails(
    GetProjectDetailsEvent event,
    Emitter<WebsiteState> emit,
  ) async {
    emit(state.copyWith(status: WebsiteStatus.loading));
    final result = await getProjectByIdUseCase(event.projectId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: WebsiteStatus.failure,
        failure: failure,
      )),
      (project) => emit(state.copyWith(
        status: WebsiteStatus.success,
        selectedProject: project,
      )),
    );
  }
}
