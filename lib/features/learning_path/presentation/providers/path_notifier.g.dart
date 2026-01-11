// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PathNotifier)
const pathProvider = PathNotifierProvider._();

final class PathNotifierProvider
    extends $AsyncNotifierProvider<PathNotifier, PathEntity> {
  const PathNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathNotifierHash();

  @$internal
  @override
  PathNotifier create() => PathNotifier();
}

String _$pathNotifierHash() => r'be37cccd8e7807a07cad87706ab6d238e449e87e';

abstract class _$PathNotifier extends $AsyncNotifier<PathEntity> {
  FutureOr<PathEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PathEntity>, PathEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PathEntity>, PathEntity>,
              AsyncValue<PathEntity>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
