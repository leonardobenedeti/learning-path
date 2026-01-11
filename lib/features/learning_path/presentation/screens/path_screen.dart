import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/path_notifier.dart';
import '../widgets/lesson_node.dart';
import 'lesson_details_screen.dart';

class PathScreen extends ConsumerWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathAsync = ref.watch(pathProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Learning Path',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: pathAsync.when(
        data: (path) {
          final lessons = path.lessons.reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return LessonNode(
                lesson: lesson,
                hasLineAbove: index > 0,
                hasLineBelow: index < lessons.length - 1,
                onTap: () {
                  if (!lesson.status.isLocked) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LessonDetailsScreen(lesson: lesson),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This lesson is locked!')),
                    );
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Progress?'),
                  content: const Text(
                    'This will lock all lessons and reset your learning path to the beginning. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(pathProvider.notifier).resetPath();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Reset Everything'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.history_rounded, color: Colors.redAccent),
            label: const Text(
              'Reset All Progress',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
