import '../../domain/entities/path_entity.dart';
import 'lesson_model.dart';

class PathModel extends PathEntity {
  const PathModel({
    required super.id,
    required super.name,
    required super.description,
    required List<LessonModel> super.lessons,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) {
    return PathModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      lessons: (json['lessons'] as List)
          .map((lesson) => LessonModel.fromJson(lesson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lessons': lessons
          .map((lesson) => (lesson as LessonModel).toJson())
          .toList(),
    };
  }
}
