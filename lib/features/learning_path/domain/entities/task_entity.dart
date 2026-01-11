import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String type;
  final int estimatedSeconds;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.estimatedSeconds,
  });

  @override
  List<Object?> get props => [id, title, type, estimatedSeconds];
}
