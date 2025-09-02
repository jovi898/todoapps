import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

class AppBarTasks extends StatefulWidget implements PreferredSizeWidget {
  const AppBarTasks({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarTasks> createState() => _AppBarTasksState();
}

class _AppBarTasksState extends State<AppBarTasks> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_outlined),
          color: AppColors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskStateWithTasks) {
            if (state.isSearching) {
              return TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  context.read<TaskBloc>().add(SearchTasks(value));
                },
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: LocaleKeys.SEARCH.tr(),
                  hintStyle: const TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                ),
              );
            } else {
              return Align(
                child: Text(
                  LocaleKeys.TO_DO_LIST.tr(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
      backgroundColor: AppColors.transparent,
      actions: [
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskStateWithTasks) {
              final isSearching = state.isSearching;

              return IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.search, color: AppColors.white),
                onPressed: () async {
                  if (isSearching) {
                    _searchController.clear();
                    context.read<TaskBloc>().add(StopSearch());
                  } else {
                    context.read<TaskBloc>().add(StartSearch());
                    await Future.delayed(
                      const Duration(milliseconds: 100),
                      _searchFocusNode.requestFocus,
                    );
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
