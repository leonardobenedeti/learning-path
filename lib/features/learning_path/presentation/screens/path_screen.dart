import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/path_notifier.dart';
import '../widgets/error_view.dart';
import '../widgets/lesson_node.dart';
import '../widgets/loading_view.dart';
import 'lesson_details_screen.dart';

class PathScreen extends ConsumerStatefulWidget {
  const PathScreen({super.key});

  @override
  ConsumerState<PathScreen> createState() => _PathScreenState();
}

class _PathScreenState extends ConsumerState<PathScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollToCurrent();
  }

  void _scrollToCurrent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pathState = ref.read(pathProvider);
      pathState.whenData((path) {
        final lessons = path.lessons;
        final currentIndex = lessons.indexWhere((l) => l.status.isCurrent);

        if (currentIndex != -1 && _scrollController.hasClients) {
          double targetOffset = currentIndex * 110.0;

          final maxScroll = _scrollController.position.maxScrollExtent;
          final minScroll = _scrollController.position.minScrollExtent;
          targetOffset = targetOffset.clamp(minScroll, maxScroll);

          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pathAsync = ref.watch(pathProvider);

    ref.listen(pathProvider, (previous, next) {
      if (next is AsyncData) {
        _scrollToCurrent();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Learning Path',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.redAccent),
            tooltip: 'Reset All Progress',
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
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        await ref.read(pathProvider.notifier).resetPath();
                        if (!mounted) return;
                        _scrollToCurrent();
                        navigator.pop();
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Reset Everything'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
      body: pathAsync.when(
        data: (path) {
          final lessons = path.lessons;
          final allCompleted = lessons.every((l) => l.status.isCompleted);

          return Stack(
            children: [
              Positioned.fill(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(0, 200, 16, 300),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return LessonNode(
                      lesson: lesson,
                      hasLineAbove: index < lessons.length - 1,
                      hasLineBelow: index > 0,
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
                            const SnackBar(
                              content: Text('This lesson is locked!'),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade700, Colors.indigo.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: allCompleted
                                  ? Colors.amber.shade400
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              allCompleted
                                  ? Icons.emoji_events_rounded
                                  : Icons.auto_stories_rounded,
                              color: allCompleted
                                  ? Colors.black87
                                  : Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              path.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        path.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      if (allCompleted) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text('🎉', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Excellent work! You\'ve mastered every lesson in this path.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const PathLoadingView(),
        error: (err, stack) => FriendlyErrorView(
          message: err.toString(),
          onRetry: () => ref.refresh(pathProvider),
        ),
      ),
    );
  }
}
