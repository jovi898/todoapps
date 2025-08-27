part of 'task_bloc.dart';

@immutable
sealed class TaskState {
  final List<Task> allTasks;
  final List<Task> visibleTasks;

  const TaskState({this.allTasks = const [], this.visibleTasks = const []});
}

class TaskInitial extends TaskState {
  const TaskInitial() : super(allTasks: const [], visibleTasks: const []);
}

class TaskLoaded extends TaskState {
  const TaskLoaded({required super.allTasks, required super.visibleTasks});
}
