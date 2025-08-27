part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class AddTask extends TaskEvent {
  final String text;

  AddTask(this.text);
}

class ToggleDone extends TaskEvent {
  final String taskId;

  ToggleDone(this.taskId);
}

class ToggleFavorite extends TaskEvent {
  final String taskId;

  ToggleFavorite(this.taskId);
}

class ToggleEditText extends TaskEvent {
  final String taskId;
  final String newText;
  ToggleEditText(this.taskId, this.newText);
}

class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks(this.query);
}

class ToggleSearch extends TaskEvent {
  final bool isSearching;

  ToggleSearch(this.isSearching);
}

class DeleteTask extends TaskEvent {
  final String taskId;

  DeleteTask(this.taskId);
}
