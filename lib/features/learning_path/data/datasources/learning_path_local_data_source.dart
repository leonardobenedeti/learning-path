import '../../../../path_response.dart';
import '../models/path_model.dart';

abstract class LearningPathLocalDataSource {
  Future<PathModel> getLearningPath();
}

class LearningPathLocalDataSourceImpl implements LearningPathLocalDataSource {
  @override
  Future<PathModel> getLearningPath() async {
    try {
      final json = pathResponse['path'] as Map<String, dynamic>;
      return PathModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to load local path data');
    }
  }
}
