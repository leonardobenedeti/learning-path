import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/path_entity.dart';
import 'presentation_providers.dart';

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
}
