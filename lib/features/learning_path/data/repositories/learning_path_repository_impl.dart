import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../path_response.dart';
import '../../domain/entities/path_entity.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../datasources/learning_path_local_data_source.dart';
import '../datasources/progress_local_data_source.dart';
import '../models/lesson_model.dart';
import '../models/path_model.dart';

class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathLocalDataSource localDataSource;
  final ProgressLocalDataSource progressLocalDataSource;

  LearningPathRepositoryImpl({
    required this.localDataSource,
    required this.progressLocalDataSource,
  });

  @override
  Future<Either<Failure, PathEntity>> getLearningPath() async {
    try {
      final pathModel = await localDataSource.getLearningPath();
      return Right(pathModel);
    } catch (e) {
      debugPrint('Error getting learning path: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateLessonStatus(
    String lessonId,
    String status,
  ) async {
    try {
      final pathModel = await localDataSource.getLearningPath();

      final List<LessonModel> lessons = pathModel.lessons.cast<LessonModel>();
      final int lessonIndex = lessons.indexWhere((l) => l.id == lessonId);

      if (lessonIndex == -1) return Left(CacheFailure());

      final updatedLessonJson = lessons[lessonIndex].toJson();
      updatedLessonJson['status'] = status;
      lessons[lessonIndex] = LessonModel.fromJson(updatedLessonJson);

      if (status == 'completed' && lessonIndex < lessons.length - 1) {
        final nextLesson = lessons[lessonIndex + 1];
        if (nextLesson.status.isLocked) {
          final nextLessonJson = nextLesson.toJson();
          nextLessonJson['status'] = 'current';
          lessons[lessonIndex + 1] = LessonModel.fromJson(nextLessonJson);
        }
      }

      final updatedPath = PathModel(
        id: pathModel.id,
        name: pathModel.name,
        description: pathModel.description,
        lessons: lessons,
      );

      await localDataSource.saveLearningPath(updatedPath);

      if (status == 'completed') {
        final completedLesson = lessons[lessonIndex];
        final taskIds = completedLesson.tasks.map((task) => task.id).toList();
        await progressLocalDataSource.saveCompletedTaskIds(taskIds);
      }

      return const Right(null);
    } catch (e) {
      debugPrint('Error updating lesson status: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPath() async {
    try {
      final initialJson = pathResponse['path'] as Map<String, dynamic>;
      final initialPath = PathModel.fromJson(initialJson);

      final List<LessonModel> lessons = initialPath.lessons.cast<LessonModel>();

      for (int i = 0; i < lessons.length; i++) {
        final lessonJson = lessons[i].toJson();
        lessonJson['status'] = i == 0 ? 'current' : 'locked';
        lessons[i] = LessonModel.fromJson(lessonJson);
      }

      final updatedPath = PathModel(
        id: initialPath.id,
        name: initialPath.name,
        description: initialPath.description,
        lessons: lessons,
      );

      await localDataSource.saveLearningPath(updatedPath);
      await progressLocalDataSource.clear();

      return const Right(null);
    } catch (e) {
      debugPrint('Error resetting path: $e');
      return Left(CacheFailure());
    }
  }
}
