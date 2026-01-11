import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/path_entity.dart';
import '../repositories/learning_path_repository.dart';

class GetLearningPathUseCase {
  final LearningPathRepository repository;

  GetLearningPathUseCase(this.repository);

  Future<Either<Failure, PathEntity>> execute() async {
    return await repository.getLearningPath();
  }
}
