import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource localDataSource;

  ProgressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<String>>> getCompletedTaskIds() async {
    try {
      final taskIds = await localDataSource.getCompletedTaskIds();
      return Right(taskIds);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> completeTask(String taskId) async {
    try {
      await localDataSource.saveCompletedTaskId(taskId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uncompleteTask(String taskId) async {
    try {
      await localDataSource.removeCompletedTaskId(taskId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetTasks(List<String> taskIds) async {
    try {
      await localDataSource.removeCompletedTaskIds(taskIds);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetProgress() async {
    try {
      await localDataSource.clear();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
