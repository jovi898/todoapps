import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/widgets/list_card.dart';

class DeleteSlideTask extends StatelessWidget {
  const DeleteSlideTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return switch (state) {
          TaskStateWithTasks(visibleTasks: final tasksToShow) => ListView.builder(
            itemCount: tasksToShow.length,
            itemBuilder: (context, index) {
              final task = tasksToShow[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Slidable(
                  key: ValueKey(task.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                        },
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        icon: Icons.delete,
                        label: LocaleKeys.DELETE.tr(),
                      ),
                    ],
                  ),
                  child: ListCard(task: task),
                ),
              );
            },
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
