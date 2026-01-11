import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'presentation_providers.dart';

part 'progress_notifier.g.dart';

@riverpod
class ProgressNotifier extends _$ProgressNotifier {
  @override
  FutureOr<List<String>> build() async {
    final repository = ref.watch(progressRepositoryProvider);
    final result = await repository.getCompletedTaskIds();

    return result.fold((failure) => [], (taskIds) => taskIds);
  }

  Future<void> completeTask(String taskId) async {
    final repository = ref.read(progressRepositoryProvider);
    final result = await repository.completeTask(taskId);

    result.fold((failure) => null, (_) {
      final current = state.value ?? [];
      if (!current.contains(taskId)) {
        state = AsyncValue.data([...current, taskId]);
      }
    });
  }

  Future<void> uncompleteTask(String taskId) async {
    final repository = ref.read(progressRepositoryProvider);
    final result = await repository.uncompleteTask(taskId);

    result.fold((failure) => null, (_) {
      final current = state.value ?? [];
      if (current.contains(taskId)) {
        state = AsyncValue.data(current.where((id) => id != taskId).toList());
      }
    });
  }

  Future<void> toggleTask(String taskId, bool isCompleted) async {
    if (isCompleted) {
      await uncompleteTask(taskId);
    } else {
      await completeTask(taskId);
    }
  }

  Future<void> resetTasks(List<String> taskIds) async {
    final repository = ref.read(progressRepositoryProvider);
    await repository.resetTasks(taskIds);
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.where((id) => !taskIds.contains(id)).toList(),
    );
  }

  Future<void> resetProgress() async {
    final repository = ref.read(progressRepositoryProvider);
    await repository.resetProgress();
    state = const AsyncValue.data([]);
  }
}
