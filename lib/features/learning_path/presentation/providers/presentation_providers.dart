import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/learning_path_local_data_source.dart';
import '../../data/datasources/progress_local_data_source.dart';
import '../../data/repositories/learning_path_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../../domain/usecases/reset_path_usecase.dart';
import '../../domain/usecases/update_lesson_status_usecase.dart';

part 'presentation_providers.g.dart';

@riverpod
LearningPathLocalDataSource learningPathLocalDataSource(Ref ref) {
  return LearningPathLocalDataSourceImpl();
}

@riverpod
LearningPathRepository learningPathRepository(Ref ref) {
  final localDataSource = ref.watch(learningPathLocalDataSourceProvider);
  final progressDataSource = ref.watch(progressLocalDataSourceProvider);
  return LearningPathRepositoryImpl(
    localDataSource: localDataSource,
    progressLocalDataSource: progressDataSource,
  );
}

@riverpod
GetLearningPathUseCase getLearningPathUseCase(Ref ref) {
  final repository = ref.watch(learningPathRepositoryProvider);
  return GetLearningPathUseCase(repository);
}

@riverpod
ProgressLocalDataSource progressLocalDataSource(Ref ref) {
  return ProgressLocalDataSourceImpl();
}

@riverpod
ProgressRepository progressRepository(Ref ref) {
  final localDataSource = ref.watch(progressLocalDataSourceProvider);
  return ProgressRepositoryImpl(localDataSource: localDataSource);
}

@riverpod
UpdateLessonStatusUseCase updateLessonStatusUseCase(Ref ref) {
  final repository = ref.watch(learningPathRepositoryProvider);
  return UpdateLessonStatusUseCase(repository);
}

@riverpod
ResetPathUseCase resetPathUseCase(Ref ref) {
  final repository = ref.watch(learningPathRepositoryProvider);
  return ResetPathUseCase(repository);
}
