import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/path_notifier.dart';
import '../widgets/lesson_node.dart';

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
                  // TODO(leo): Navigate to tasks
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
