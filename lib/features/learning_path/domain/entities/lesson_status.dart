enum LessonStatus {
  completed,
  current,
  locked;

  bool get isCompleted => this == LessonStatus.completed;
  bool get isCurrent => this == LessonStatus.current;
  bool get isLocked => this == LessonStatus.locked;

  static LessonStatus fromString(String status) {
    return LessonStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => LessonStatus.locked,
    );
  }
}
