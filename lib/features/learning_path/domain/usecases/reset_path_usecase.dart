import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/learning_path_repository.dart';

class ResetPathUseCase {
  final LearningPathRepository repository;

  ResetPathUseCase(this.repository);

  Future<Either<Failure, void>> execute() async {
    return await repository.resetPath();
  }
}
