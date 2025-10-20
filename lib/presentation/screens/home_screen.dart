import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/core/constants/app_text_styles.dart';
import 'package:todoapp/core/constants/assets.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/widgets/appbar_tasks.dart';
import 'package:todoapp/presentation/widgets/delete_slidable_task.dart';
import 'package:todoapp/presentation/widgets/drawer_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  String get _text => _controller.text.replaceAll(' ', '');

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
      drawer: const DrawerTasks(),
      body: BlocBuilder<BackgroundCubit, Uint8List?>(
        builder: (context, imageBytes) {
          final ImageProvider backgroundImage = imageBytes == null
              ? const AssetImage(AppAssets.background)
              : MemoryImage(imageBytes);
          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return switch (state) {
                TaskStateWithTasks() => DecoratedBox(
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
                            key: const Key('ADD_TASK'),
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
                                  if (_text.isNotEmpty) {
                                    context.read<TaskBloc>().add(AddTask(_text));
                                    _controller.clear();
                                  }
                                },
                              ),
                              fillColor: AppColors.blueWithOpacity,
                              filled: true,
                              focusedBorder: AppTextStyles.borderFocusAndEnabled,
                              enabledBorder: AppTextStyles.borderFocusAndEnabled,
                            ),
                            onFieldSubmitted: (value) {
                              if (_text.isNotEmpty) {
                                context.read<TaskBloc>().add(AddTask(_text));
                                _controller.clear();
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                          const Expanded(child: DeleteSlideTask()),
                        ],
                      ),
                    ),
                  ),
                ),
                TaskFailure(message: final e) => Text("Ошибка: $e"),
                _ => const SizedBox.shrink(),
              };
            },
          );
        },
      ),
    );
  }
}
