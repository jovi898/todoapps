import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/models/task.dart';
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
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined),
          color: AppColors.white,
          onPressed: () {},
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  context.read<TaskBloc>().add(SearchTasks(value));
                },
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  hintText: 'Поиск...',
                  hintStyle: TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                ),
              )
            : const Text('To Do List', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: AppColors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<TaskBloc>().add(SearchTasks(''));
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text("Меню", style: TextStyle(color: AppColors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Главная"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Настройки"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final List<Task> tasksToShow;
          if (state is TaskLoaded) {
            tasksToShow = state.visibleTasks;
          } else {
            tasksToShow = const [];
          }
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
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
                              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.add, size: 28),
                                color: AppColors.grey,
                                onPressed: () {
                                  final text = _controller.text.trim();
                                  if (text.isNotEmpty) {
                                    context.read<TaskBloc>().add(AddTask(text));
                                    _controller.clear();
                                  }
                                },
                              ),
                              fillColor: AppColors.transparentHalf,
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: tasksToShow.isEmpty
                          ? Center(
                              child: Container(
                                width: 140,
                                decoration: const BoxDecoration(
                                  color: AppColors.transparentHalf,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'Список пуст',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: tasksToShow.length,
                              itemBuilder: (context, index) {
                                final task = tasksToShow[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Slidable(
                                    key: Key(task.id),
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
                                          label: 'Удалить',
                                        ),
                                      ],
                                    ),
                                    child: ListCard(task: task, index: index),
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
        },
      ),
    );
  }
}
