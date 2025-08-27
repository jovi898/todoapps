import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/utils/app_colors.dart';

class ListCard extends StatelessWidget {
  final Task task;
  final int index;
  const ListCard({required this.task, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              size: 28,
              task.isDone ? Icons.check_circle : Icons.circle_outlined,
              color: AppColors.blue,
            ),
            highlightColor: AppColors.transparent,
            onPressed: () => context.read<TaskBloc>().add(ToggleDone(task.id)),
          ),
          Expanded(
            child: Text(
              task.text,
              style: TextStyle(
                color: task.isDone ? AppColors.blue : AppColors.black,
                decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _toggleEditText(context),
            highlightColor: AppColors.transparent,
          ),
          IconButton(
            icon: Icon(
              task.favorite ? Icons.star : Icons.star_border,
              color: task.favorite ? AppColors.blue : AppColors.grey,
            ),
            onPressed: () => context.read<TaskBloc>().add(ToggleFavorite(task.id)),
            highlightColor: AppColors.transparent,
          ),
        ],
      ),
    );
  }

  Future<void> _toggleEditText(BuildContext context) async {
    // ignore: move-variable-closer-to-its-usage
    final bloc = context.read<TaskBloc>();
    final newText = await showGeneralDialog<String>(
      context: context,
      transitionDuration: const Duration(milliseconds: 700),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.linearToEaseOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        final controller = TextEditingController(text: task.text);
        return AlertDialog(
          title: const Text("Редактировать"),
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: (value) => Navigator.pop(context, controller.text.trim()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
    if (!context.mounted) return;
    if (newText != null && newText.trim().isNotEmpty) {
      bloc.add(ToggleEditText(task.id, newText.trim()));
    }
  }
}
