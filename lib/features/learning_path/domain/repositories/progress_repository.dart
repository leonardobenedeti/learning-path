import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<String>>> getCompletedTaskIds();
  Future<Either<Failure, void>> completeTask(String taskId);
  Future<Either<Failure, void>> uncompleteTask(String taskId);
  Future<Either<Failure, void>> resetTasks(List<String> taskIds);
  Future<Either<Failure, void>> resetProgress();
}
