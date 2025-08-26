import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/utils/app_colors.dart';
import 'package:todoapp/utils/app_text_styles.dart';
import 'package:todoapp/widgets/list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu_outlined, color: AppColors.white),
        title: const Text(
          'To Do List',
          style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search), color: AppColors.white),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: const Text(
                        'Groceries',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    // ignore: avoid-single-child-column-or-row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                              hintText: 'Add a task..',
                              hintStyle: const TextStyle(color: AppColors.black, fontSize: 14),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.add, size: 28),
                                color: AppColors.black,
                                onPressed: _addTask,
                              ),
                              fillColor: AppColors.transparentHalf,
                              filled: true,
                              focusedBorder: AppTextStyles.borderFocusAndEnabled,
                              enabledBorder: AppTextStyles.borderFocusAndEnabled,
                            ),
                            onFieldSubmitted: (value) => _addTask(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: state.tasks.isEmpty
                          ? const Center(
                              child: Text(
                                'Список пуст',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                final task = state.tasks[index];
                                return ListCard(
                                  task: task,
                                  index: index,
                                  onToggleDone: _updateTaskDone,
                                  onToggleFavorite: _updateTaskFavorite,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateTaskDone(int index) {
    context.read<TaskBloc>().add(ToggleDone(index));
  }

  void _updateTaskFavorite(int index) {
    context.read<TaskBloc>().add(ToggleFavorite(index));
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<TaskBloc>().add(AddTask(text.trim()));
      _controller.clear();
    }
  }
}
