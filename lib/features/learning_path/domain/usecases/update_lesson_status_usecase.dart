import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/learning_path_repository.dart';

class UpdateLessonStatusUseCase {
  final LearningPathRepository repository;

  UpdateLessonStatusUseCase(this.repository);

  Future<Either<Failure, void>> execute(String lessonId, String status) async {
    return await repository.updateLessonStatus(lessonId, status);
  }
}
