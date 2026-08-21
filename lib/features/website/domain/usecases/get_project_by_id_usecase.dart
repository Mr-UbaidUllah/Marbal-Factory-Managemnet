import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';

class GetProjectByIdUseCase {
  final WebsiteRepository repository;

  GetProjectByIdUseCase(this.repository);

  Future<Either<Failure, Project>> call(String id) {
    return repository.getProjectById(id);
  }
}
