import 'package:equatable/equatable.dart';

import 'lesson_status.dart';
import 'task_entity.dart';

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final int position;
  final LessonStatus status;
  final int xp;
  final int estimatedMinutes;
  final List<TaskEntity> tasks;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.position,
    required this.status,
    required this.xp,
    required this.estimatedMinutes,
    required this.tasks,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    position,
    status,
    xp,
    estimatedMinutes,
    tasks,
  ];
}
