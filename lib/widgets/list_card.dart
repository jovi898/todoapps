import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/utils/app_colors.dart';

class ListCard extends StatefulWidget {
  final Task task;
  final int index;
  final void Function(int) onToggleDone;
  final void Function(int) onToggleFavorite;
  const ListCard({
    required this.task,
    required this.index,
    required this.onToggleDone,
    required this.onToggleFavorite,
    super.key,
  });

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
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
                widget.task.isDone ? Icons.check_circle : Icons.circle_outlined,
                color: AppColors.blue,
              ),
              highlightColor: Colors.transparent,
              onPressed: () => widget.onToggleDone(widget.index),
            ),
            Expanded(
              child: Text(
                widget.task.text,
                style: TextStyle(
                  color: widget.task.isDone ? AppColors.blue : AppColors.black,
                  decoration: widget.task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditText,
              highlightColor: AppColors.transparent,
            ),
            IconButton(
              icon: Icon(
                widget.task.favorite ? Icons.star : Icons.star_border,
                color: widget.task.favorite ? AppColors.blue : AppColors.grey,
              ),
              onPressed: () => widget.onToggleFavorite(widget.index),
              highlightColor: AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleEditText() async {
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
        final controller = TextEditingController(text: widget.task.text);
        return AlertDialog(
          title: const Text("Редактировать"),
          content: TextField(controller: controller, autofocus: true),
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
    if (!mounted) return;
    if (newText != null && newText.isNotEmpty) {
      context.read<TaskBloc>().add(ToggleEditText(widget.index, newText));
    }
  }
}
