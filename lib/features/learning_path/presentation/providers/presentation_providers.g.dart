// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learningPathLocalDataSource)
const learningPathLocalDataSourceProvider =
    LearningPathLocalDataSourceProvider._();

final class LearningPathLocalDataSourceProvider
    extends
        $FunctionalProvider<
          LearningPathLocalDataSource,
          LearningPathLocalDataSource,
          LearningPathLocalDataSource
        >
    with $Provider<LearningPathLocalDataSource> {
  const LearningPathLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningPathLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningPathLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<LearningPathLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningPathLocalDataSource create(Ref ref) {
    return learningPathLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningPathLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningPathLocalDataSource>(value),
    );
  }
}

String _$learningPathLocalDataSourceHash() =>
    r'a59cd3d457500806ee3e4651a695b81308f071ab';

@ProviderFor(learningPathRepository)
const learningPathRepositoryProvider = LearningPathRepositoryProvider._();

final class LearningPathRepositoryProvider
    extends
        $FunctionalProvider<
          LearningPathRepository,
          LearningPathRepository,
          LearningPathRepository
        >
    with $Provider<LearningPathRepository> {
  const LearningPathRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningPathRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningPathRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearningPathRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningPathRepository create(Ref ref) {
    return learningPathRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningPathRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningPathRepository>(value),
    );
  }
}

String _$learningPathRepositoryHash() =>
    r'ff14c1fc77226242a7f781340f5bc790fdf4db8b';

@ProviderFor(getLearningPathUseCase)
const getLearningPathUseCaseProvider = GetLearningPathUseCaseProvider._();

final class GetLearningPathUseCaseProvider
    extends
        $FunctionalProvider<
          GetLearningPathUseCase,
          GetLearningPathUseCase,
          GetLearningPathUseCase
        >
    with $Provider<GetLearningPathUseCase> {
  const GetLearningPathUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getLearningPathUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getLearningPathUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLearningPathUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetLearningPathUseCase create(Ref ref) {
    return getLearningPathUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLearningPathUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetLearningPathUseCase>(value),
    );
  }
}

String _$getLearningPathUseCaseHash() =>
    r'6ec1c6221d769fd9b5097df5a2660aab1fa944a6';
