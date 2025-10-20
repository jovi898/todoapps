part of 'task_bloc.dart';

@immutable
sealed class TaskEvent extends Equatable {}

class LoadTasks extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final String text;

  AddTask(this.text);
  @override
  List<Object?> get props => [text];
}

class ToggleDone extends TaskEvent {
  final int taskId;

  ToggleDone(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class FreezeTask extends TaskEvent {
  final int taskId;

  FreezeTask(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class UnFreezeTask extends TaskEvent {
  final int taskId;

  UnFreezeTask(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class StartEditingTask extends TaskEvent {
  final int taskId;
  StartEditingTask(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class StopEditingTask extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class UpdateTaskText extends TaskEvent {
  final int taskId;
  final String newText;
  UpdateTaskText(this.taskId, this.newText);
  @override
  List<Object?> get props => [taskId, newText];
}

class DeleteTask extends TaskEvent {
  final int taskId;

  DeleteTask(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class SearchTasks extends TaskEvent {
  final String query;

  SearchTasks(this.query);
  @override
  List<Object?> get props => [query];
}

class StartSearch extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class StopSearch extends TaskEvent {
  @override
  List<Object?> get props => [];
}
