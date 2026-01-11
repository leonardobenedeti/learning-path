import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/learning_path_local_data_source.dart';
import '../../data/repositories/learning_path_repository_impl.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';

part 'presentation_providers.g.dart';

@riverpod
LearningPathLocalDataSource learningPathLocalDataSource(Ref ref) {
  return LearningPathLocalDataSourceImpl();
}

@riverpod
LearningPathRepository learningPathRepository(Ref ref) {
  final localDataSource = ref.watch(learningPathLocalDataSourceProvider);
  return LearningPathRepositoryImpl(localDataSource: localDataSource);
}

@riverpod
GetLearningPathUseCase getLearningPathUseCase(Ref ref) {
  final repository = ref.watch(learningPathRepositoryProvider);
  return GetLearningPathUseCase(repository);
}
