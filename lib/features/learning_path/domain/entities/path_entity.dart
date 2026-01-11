import 'package:equatable/equatable.dart';

import 'lesson_entity.dart';

class PathEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<LessonEntity> lessons;

  const PathEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.lessons,
  });

  @override
  List<Object?> get props => [id, name, description, lessons];
}
