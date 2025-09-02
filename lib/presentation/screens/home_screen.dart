import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/core/constants/app_text_styles.dart';
import 'package:todoapp/core/constants/assets.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/screens/cubit/background_cubit.dart';
import 'package:todoapp/presentation/widgets/list_card.dart';
import 'package:todoapp/presentation/widgets/tasks_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const AppBarTasks(),
      drawer: ColoredBox(
        color: AppColors.blackWithOpacity,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 60, backgroundImage: AssetImage(AppAssets.avatar)),
                    Text(LocaleKeys.NAME_USER.tr(), style: AppTextStyles.boldTextWhite),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: AppColors.white),
                title: Text(LocaleKeys.HOME.tr(), style: AppTextStyles.middleTextWhite),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.white),
                title: Text(
                  LocaleKeys.SETTINGS.tr(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  context.goNamed('settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallpaper, color: AppColors.white),
                title: Text(LocaleKeys.WALLPAPER.tr(), style: AppTextStyles.middleTextWhite),
                onTap: _pickBackgroundImage,
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<BackgroundCubit, String?>(
        builder: (context, backgroundPath) {
          final ImageProvider backgroundImage = backgroundPath == null
              ? const AssetImage(AppAssets.background)
              : FileImage(File(backgroundPath));
          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state case TaskStateWithTasks(visibleTasks: final tasksToShow)) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Text(LocaleKeys.NOTES.tr(), style: AppTextStyles.boldTextWhite),
                          ),
                          TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(18),
                              hintText: LocaleKeys.ADD_TASK.tr(),
                              hintStyle: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add, size: 28),
                                color: AppColors.black,
                                onPressed: () {
                                  final text = _controller.text.trim();
                                  if (text.isNotEmpty) {
                                    context.read<TaskBloc>().add(AddTask(text));
                                    _controller.clear();
                                  }
                                },
                              ),
                              fillColor: AppColors.bluekWithOpacity,
                              filled: true,
                              focusedBorder: AppTextStyles.borderFocusAndEnabled,
                              enabledBorder: AppTextStyles.borderFocusAndEnabled,
                            ),
                            onFieldSubmitted: (value) {
                              final text = _controller.text.trim();
                              if (text.isNotEmpty) {
                                context.read<TaskBloc>().add(AddTask(text));
                                _controller.clear();
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Future<void> _pickBackgroundImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      context.read<BackgroundCubit>().changeBackground(image.path);
    }
  }
}
