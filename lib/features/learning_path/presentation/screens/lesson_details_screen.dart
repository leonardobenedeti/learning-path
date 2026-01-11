import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/lesson_entity.dart';
import '../providers/path_notifier.dart';
import '../providers/progress_notifier.dart';
import '../widgets/horizontal_progress_line.dart';

class LessonDetailsScreen extends ConsumerStatefulWidget {
  final LessonEntity lesson;

  const LessonDetailsScreen({super.key, required this.lesson});

  @override
  ConsumerState<LessonDetailsScreen> createState() =>
      _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends ConsumerState<LessonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.lesson.status.isCompleted)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.purple),
              onPressed: () {
                final taskIds = widget.lesson.tasks.map((t) => t.id).toList();
                ref.read(progressProvider.notifier).resetTasks(taskIds);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lesson tasks reset for review'),
                  ),
                );
              },
              tooltip: 'Reset Lesson',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: progressAsync.when(
        data: (completedIds) {
          final bool isInitialyCompleted = widget.lesson.status.isCompleted;

          final completedTasksInLesson = widget.lesson.tasks
              .where((task) => completedIds.contains(task.id))
              .length;

          final bool allTasksDone =
              completedTasksInLesson == widget.lesson.tasks.length;

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lesson Progress',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$completedTasksInLesson / ${widget.lesson.tasks.length} tasks',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    HorizontalProgressLine(
                      totalSteps: widget.lesson.tasks.length,
                      completedSteps: completedTasksInLesson,
                      activeColor: Colors.purple,
                      inactiveColor: Colors.purple.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  itemCount: widget.lesson.tasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.lesson.tasks[index];
                    final isCompleted = completedIds.contains(task.id);

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: 1.0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isCompleted
                                ? Colors.purple.withValues(alpha: 0.2)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ListTile(
                            onTap: () {
                              ref
                                  .read(progressProvider.notifier)
                                  .toggleTask(task.id, isCompleted);
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.purple.withValues(alpha: 0.1)
                                    : Colors.grey.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getTaskIcon(task.type),
                                color: isCompleted
                                    ? Colors.purple
                                    : Colors.grey.shade600,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isCompleted
                                    ? Colors.grey.shade500
                                    : Colors.black87,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                task.type.replaceAll('_', ' ').toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.purple.withValues(alpha: 0.6),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            trailing: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.purple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCompleted
                                      ? Colors.purple
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (!isInitialyCompleted)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: allTasksDone
                            ? () {
                                ref
                                    .read(pathProvider.notifier)
                                    .updateLessonStatus(
                                      widget.lesson.id,
                                      'completed',
                                    );
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allTasksDone
                              ? Colors.green
                              : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          elevation: allTasksDone ? 4 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Complete Lesson',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.purple),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTaskIcon(String type) {
    switch (type) {
      case 'listen_repeat':
        return Icons.headset_rounded;
      case 'multiple_choice':
        return Icons.quiz_rounded;
      case 'fill_in_the_blanks':
        return Icons.edit_note_rounded;
      case 'ordering':
        return Icons.low_priority_rounded;
      case 'role_play':
        return Icons.record_voice_over_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }
}
