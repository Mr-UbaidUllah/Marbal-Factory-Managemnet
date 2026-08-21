import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';

class GetProjectsUseCase {
  final WebsiteRepository repository;

  GetProjectsUseCase(this.repository);

  Future<Either<Failure, List<Project>>> call() {
    return repository.getProjects();
  }
}
