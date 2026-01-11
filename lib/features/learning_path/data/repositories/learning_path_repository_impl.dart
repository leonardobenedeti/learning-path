import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/path_entity.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../datasources/learning_path_local_data_source.dart';

class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathLocalDataSource localDataSource;

  LearningPathRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PathEntity>> getLearningPath() async {
    try {
      final pathModel = await localDataSource.getLearningPath();
      return Right(pathModel);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
