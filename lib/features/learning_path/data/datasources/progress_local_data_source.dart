import 'package:shared_preferences/shared_preferences.dart';

abstract class ProgressLocalDataSource {
  Future<List<String>> getCompletedTaskIds();
  Future<void> saveCompletedTaskId(String taskId);
  Future<void> saveCompletedTaskIds(List<String> taskIds);
  Future<void> removeCompletedTaskId(String taskId);
  Future<void> removeCompletedTaskIds(List<String> taskIds);
  Future<void> clear();
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  static const String _tasksKey = 'completed_tasks';

  @override
  Future<List<String>> getCompletedTaskIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_tasksKey) ?? [];
  }

  @override
  Future<void> saveCompletedTaskId(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTasks = prefs.getStringList(_tasksKey) ?? [];
    if (!currentTasks.contains(taskId)) {
      currentTasks.add(taskId);
      await prefs.setStringList(_tasksKey, currentTasks);
    }
  }

  @override
  Future<void> saveCompletedTaskIds(List<String> taskIds) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTasks = prefs.getStringList(_tasksKey) ?? [];
    final updatedTasks = {...currentTasks, ...taskIds}.toList();
    await prefs.setStringList(_tasksKey, updatedTasks);
  }

  @override
  Future<void> removeCompletedTaskId(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTasks = prefs.getStringList(_tasksKey) ?? [];
    if (currentTasks.remove(taskId)) {
      await prefs.setStringList(_tasksKey, currentTasks);
    }
  }

  @override
  Future<void> removeCompletedTaskIds(List<String> taskIds) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTasks = prefs.getStringList(_tasksKey) ?? [];
    currentTasks.removeWhere((id) => taskIds.contains(id));
    await prefs.setStringList(_tasksKey, currentTasks);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
