import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/utils/app_colors.dart';
import 'package:todoapp/utils/app_text_styles.dart';

class ListCard extends StatelessWidget {
  final Task task;
  final int index;
  const ListCard({required this.task, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(208, 255, 255, 255),
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
    final newText = await showModalBottomSheet<String>(
      backgroundColor: Colors.black.withOpacity(0.3),
      context: context,
      scrollControlDisabledMaxHeightRatio: 6.0 / 16.0,
      builder: (context) {
        final controller = TextEditingController(text: task.text);
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Задача не должна быть пустым',
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                  fillColor: AppColors.transparentHalf,
                  filled: true,
                  focusedBorder: AppTextStyles.borderFocusAndEnabled,
                  enabledBorder: AppTextStyles.borderFocusAndEnabled,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
                controller: controller,
                autofocus: true,
                onSubmitted: (value) => Navigator.pop(context, controller.text.trim()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Отмена",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    if (!context.mounted) return;
    if (newText != null && newText.trim().isNotEmpty) {
      context.read<TaskBloc>().add(ToggleEditText(task.id, newText.trim()));
    }
  }
}
