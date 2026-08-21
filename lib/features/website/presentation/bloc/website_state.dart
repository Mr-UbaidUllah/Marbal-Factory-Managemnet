import 'package:equatable/equatable.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';

enum WebsiteStatus { initial, loading, success, failure }

class WebsiteState extends Equatable {
  final WebsiteStatus status;
  final List<Product> featuredProducts;
  final List<Project> projects;
  final Project? selectedProject;
  final Failure? failure;
  final bool isQuoteSubmitting;
  final bool isQuoteSuccess;

  const WebsiteState({
    this.status = WebsiteStatus.initial,
    this.featuredProducts = const [],
    this.projects = const [],
    this.selectedProject,
    this.failure,
    this.isQuoteSubmitting = false,
    this.isQuoteSuccess = false,
  });

  WebsiteState copyWith({
    WebsiteStatus? status,
    List<Product>? featuredProducts,
    List<Project>? projects,
    Project? selectedProject,
    Failure? failure,
    bool? isQuoteSubmitting,
    bool? isQuoteSuccess,
  }) {
    return WebsiteState(
      status: status ?? this.status,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      failure: failure ?? this.failure,
      isQuoteSubmitting: isQuoteSubmitting ?? this.isQuoteSubmitting,
      isQuoteSuccess: isQuoteSuccess ?? this.isQuoteSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        featuredProducts,
        projects,
        selectedProject,
        failure,
        isQuoteSubmitting,
        isQuoteSuccess,
      ];
}
