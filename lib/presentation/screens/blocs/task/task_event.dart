part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String text;

  AddTask(this.text);
}

class ToggleDone extends TaskEvent {
  final int taskId;

  ToggleDone(this.taskId);
}

class FreezeTask extends TaskEvent {
  final int taskId;

  FreezeTask(this.taskId);
}

class UnFreezeTask extends TaskEvent {
  final int taskId;

  UnFreezeTask(this.taskId);
}

class StartEditingTask extends TaskEvent {
  final int taskId;
  StartEditingTask(this.taskId);
}

class StopEditingTask extends TaskEvent {}

class UpdateTaskText extends TaskEvent {
  final int taskId;
  final String newText;
  UpdateTaskText(this.taskId, this.newText);
}

class DeleteTask extends TaskEvent {
  final int taskId;

  DeleteTask(this.taskId);
}

class SearchTasks extends TaskEvent {
  final String query;

  SearchTasks(this.query);
}

class StartSearch extends TaskEvent {}

class StopSearch extends TaskEvent {}
