import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/path_entity.dart';

abstract class LearningPathRepository {
  Future<Either<Failure, PathEntity>> getLearningPath();
}
