import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/path_entity.dart';
import 'presentation_providers.dart';
import 'progress_notifier.dart';

part 'path_notifier.g.dart';

@riverpod
class PathNotifier extends _$PathNotifier {
  @override
  FutureOr<PathEntity> build() async {
    final useCase = ref.watch(getLearningPathUseCaseProvider);
    final result = await useCase.execute();

    return result.fold(
      (failure) => throw Exception('Failed to load path'),
      (path) => path,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getLearningPathUseCaseProvider);
      final result = await useCase.execute();
      return result.fold(
        (failure) => throw Exception('Failed to load path'),
        (path) => path,
      );
    });
  }

  Future<void> updateLessonStatus(String lessonId, String status) async {
    final useCase = ref.read(updateLessonStatusUseCaseProvider);
    final result = await useCase.execute(lessonId, status);

    result.fold((failure) => null, (_) => refresh());
  }

  Future<void> resetPath() async {
    final useCase = ref.read(resetPathUseCaseProvider);
    final result = await useCase.execute();

    result.fold((failure) => null, (_) {
      ref.read(progressProvider.notifier).resetProgress();
      refresh();
    });
  }
}
