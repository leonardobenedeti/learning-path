import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/lesson_entity.dart';
import '../providers/progress_notifier.dart';
import 'path_line_painter.dart';

class LessonProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  LessonProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - paint.strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28319 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(LessonProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class LessonNode extends ConsumerWidget {
  final LessonEntity lesson;
  final bool hasLineAbove;
  final bool hasLineBelow;
  final VoidCallback onTap;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.hasLineAbove,
    required this.hasLineBelow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    final bool isCompleted = lesson.status.isCompleted;
    final bool isCurrent = lesson.status.isCurrent;
    final bool isLocked = lesson.status.isLocked;

    final Color nodeColor = isCompleted
        ? Colors.green.shade600
        : (isCurrent ? Colors.purple.shade600 : Colors.grey.shade400);

    return InkWell(
      onTap: onTap,
      splashColor: nodeColor.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: Container(
        height: 110,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: CustomPaint(
                painter: PathLinePainter(
                  hasLineAbove: hasLineAbove,
                  hasLineBelow: hasLineBelow,
                  color: isCompleted || isCurrent
                      ? Colors.purple.shade100
                      : Colors.grey.shade200,
                ),
                child: Center(
                  child: progressAsync.when(
                    data: (completedIds) {
                      final completedTasksInLesson = isCompleted
                          ? lesson.tasks.length
                          : lesson.tasks
                                .where((task) => completedIds.contains(task.id))
                                .length;
                      final double progress = lesson.tasks.isEmpty
                          ? 0
                          : completedTasksInLesson / lesson.tasks.length;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!isLocked && progress > 0)
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return CustomPaint(
                                  size: const Size(66, 66),
                                  painter: LessonProgressPainter(
                                    progress: value,
                                    color: nodeColor,
                                  ),
                                );
                              },
                            ),
                          if (!isLocked && progress == 0 && isCurrent)
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: nodeColor.withValues(alpha: 0.2),
                                  width: 4,
                                ),
                              ),
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: isCurrent && progress < 1
                                  ? Colors.white
                                  : nodeColor,
                              shape: BoxShape.circle,
                              border: isCurrent && progress < 1
                                  ? Border.all(color: nodeColor, width: 4)
                                  : null,
                              boxShadow: [
                                if (isCurrent)
                                  BoxShadow(
                                    color: nodeColor.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isCompleted && progress == 1
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Text(
                                      '${lesson.position}',
                                      style: TextStyle(
                                        color: isCurrent && progress < 1
                                            ? nodeColor
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: isCurrent
                          ? Colors.purple.shade900
                          : Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: nodeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${lesson.xp} XP',
                          style: TextStyle(
                            color: nodeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•  ${lesson.estimatedMinutes} min',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLocked)
              Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20),
            if (!isLocked && isCompleted)
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
