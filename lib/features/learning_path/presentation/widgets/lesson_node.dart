import 'package:flutter/material.dart';

import '../../domain/entities/lesson_entity.dart';
import 'path_line_painter.dart';

class LessonNode extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool isCompleted = lesson.status.isCompleted;
    final bool isCurrent = lesson.status.isCurrent;

    final Color nodeColor = isCompleted
        ? Colors.green.shade600
        : (isCurrent ? Colors.purple.shade600 : Colors.grey.shade400);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: CustomPaint(
                painter: PathLinePainter(
                  hasLineAbove: hasLineAbove,
                  hasLineBelow: hasLineBelow,
                  color: isCompleted || isCurrent
                      ? Colors.purple.shade200
                      : Colors.grey.shade300,
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.white : nodeColor,
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: nodeColor, width: 4)
                          : null,
                      boxShadow: [
                        if (isCurrent)
                          BoxShadow(
                            color: nodeColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 28,
                            )
                          : Text(
                              '${lesson.position}',
                              style: TextStyle(
                                color: isCurrent ? nodeColor : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
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
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: isCurrent
                          ? Colors.purple.shade900
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: nodeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${lesson.xp} XP • ${lesson.estimatedMinutes} min',
                      style: TextStyle(
                        color: nodeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
