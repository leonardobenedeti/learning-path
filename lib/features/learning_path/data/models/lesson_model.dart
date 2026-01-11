import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_status.dart';
import 'task_model.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.position,
    required super.status,
    required super.xp,
    required super.estimatedMinutes,
    required List<TaskModel> super.tasks,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      title: json['title'],
      position: json['position'],
      status: LessonStatus.fromString(json['status']),
      xp: json['xp'],
      estimatedMinutes: json['estimatedMinutes'],
      tasks: (json['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'status': status.name,
      'xp': xp,
      'estimatedMinutes': estimatedMinutes,
      'tasks': tasks.map((task) => (task as TaskModel).toJson()).toList(),
    };
  }
}
