part of 'task_bloc.dart';

@immutable
sealed class TaskState {
  final List<Task> tasks;

  const TaskState(this.tasks);
}

class TaskInitial extends TaskState {
  const TaskInitial() : super(const []);
}

class TaskLoaded extends TaskState {
  const TaskLoaded(super.tasks);
}

class TaskSearchResult extends TaskState {
  const TaskSearchResult(super.tasks);
}
