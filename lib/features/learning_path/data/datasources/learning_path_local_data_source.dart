import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../path_response.dart';
import '../models/path_model.dart';

abstract class LearningPathLocalDataSource {
  Future<PathModel> getLearningPath();
  Future<void> saveLearningPath(PathModel path);
}

class LearningPathLocalDataSourceImpl implements LearningPathLocalDataSource {
  static const String _pathKey = 'learning_path_data';

  @override
  Future<PathModel> getLearningPath() async {
    /// Uncomment the line below to force error
    // throw Exception('Force error when try to get learning path');

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_pathKey);

    if (cachedData != null) {
      final json = jsonDecode(cachedData) as Map<String, dynamic>;
      return PathModel.fromJson(json);
    }

    final initialJson = pathResponse['path'] as Map<String, dynamic>;
    final initialPath = PathModel.fromJson(initialJson);
    await saveLearningPath(initialPath);

    final completedTaskIds = initialPath.lessons
        .where((lesson) => lesson.status.isCompleted)
        .expand((lesson) => lesson.tasks.map((task) => task.id))
        .toList();

    if (completedTaskIds.isNotEmpty) {
      final currentCompleted = prefs.getStringList('completed_tasks') ?? [];
      final uniqueTaskIds = {...currentCompleted, ...completedTaskIds}.toList();
      await prefs.setStringList('completed_tasks', uniqueTaskIds);
    }

    return initialPath;
  }

  @override
  Future<void> saveLearningPath(PathModel path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, jsonEncode(path.toJson()));
  }
}
