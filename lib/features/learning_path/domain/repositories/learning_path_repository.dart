import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/path_entity.dart';

abstract class LearningPathRepository {
  Future<Either<Failure, PathEntity>> getLearningPath();
  Future<Either<Failure, void>> updateLessonStatus(
    String lessonId,
    String status,
  );
  Future<Either<Failure, void>> resetPath();
}
