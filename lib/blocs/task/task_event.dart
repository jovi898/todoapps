part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class AddTask extends TaskEvent {
  final String text;

  AddTask(this.text);
}

class ToggleDone extends TaskEvent {
  final int index;

  ToggleDone(this.index);
}

class ToggleFavorite extends TaskEvent {
  final int index;

  ToggleFavorite(this.index);
}

class ToggleEditText extends TaskEvent {
  final int index;
  final String newText;
  ToggleEditText(this.index, this.newText);
}

class SearchTasks extends TaskEvent {
  final String search;
  SearchTasks(this.search);
}
