import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

class ListCard extends StatefulWidget {
  final Task task;
  const ListCard({required this.task, super.key});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        switch (state) {
          case TaskStateWithTasks(editingTaskId: final editingId):
            final isEditing = editingId == widget.task.id;

            return GestureDetector(
              onTap: () {
                if (isEditing) {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty && text != widget.task.text) {
                    context.read<TaskBloc>().add(UpdateTaskText(widget.task.id, text));
                  }
                } else {
                  context.read<TaskBloc>().add(StartEditingTask(widget.task.id));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.bluekWithOpacity,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      highlightColor: AppColors.transparent,
                      icon: Icon(
                        size: 28,
                        widget.task.isDone ? Icons.check_circle : Icons.circle_outlined,
                        color: AppColors.black,
                      ),
                      onPressed: () => context.read<TaskBloc>().add(ToggleDone(widget.task.id)),
                    ),
                    Expanded(
                      child: isEditing
                          ? TextField(
                              autofocus: true,
                              style: const TextStyle(fontSize: 18, height: 1, letterSpacing: 0.8),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _controller,
                              onSubmitted: (newText) {
                                if (newText.trim().isNotEmpty &&
                                    newText.trim() != widget.task.text) {
                                  context.read<TaskBloc>().add(
                                    UpdateTaskText(widget.task.id, newText.trim()),
                                  );
                                } else {
                                  context.read<TaskBloc>().add(StopEditingTask());
                                }
                              },
                            )
                          : Text(
                              widget.task.text,
                              style: TextStyle(
                                decoration: widget.task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 18,
                                height: 1,
                                letterSpacing: 0.8,
                              ),
                            ),
                    ),
                    IconButton(
                      icon: Icon(isEditing ? Icons.check : Icons.edit, color: AppColors.green),
                      onPressed: widget.task.freeze
                          ? null
                          : () {
                              if (isEditing) {
                                final text = _controller.text.trim();
                                if (text.isNotEmpty && text != widget.task.text) {
                                  context.read<TaskBloc>().add(
                                    UpdateTaskText(widget.task.id, text),
                                  );
                                } else {
                                  context.read<TaskBloc>().add(StopEditingTask());
                                }
                              } else {
                                context.read<TaskBloc>().add(StartEditingTask(widget.task.id));
                              }
                            },
                    ),
                    IconButton(
                      highlightColor: AppColors.transparent,
                      icon: Icon(
                        widget.task.freeze ? Icons.block : Icons.lock_open,
                        color: widget.task.freeze ? AppColors.white : AppColors.black,
                      ),
                      onPressed: () => widget.task.freeze
                          ? context.read<TaskBloc>().add(UnFreezeTask(widget.task.id))
                          : context.read<TaskBloc>().add(FreezeTask(widget.task.id)),
                    ),
                  ],
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
