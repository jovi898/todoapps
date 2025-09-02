part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

class TaskStateWithTasks extends TaskState {
  final List<Task> allTasks;
  final List<Task> visibleTasks;
  final int? editingTaskId;
  final bool isSearching;
  final String searchQuery;

  TaskStateWithTasks({
    this.allTasks = const [],
    this.visibleTasks = const [],
    this.editingTaskId,
    this.isSearching = false,
    this.searchQuery = "",
  });

  TaskStateWithTasks copyWith({
    List<Task>? allTasks,
    List<Task>? visibleTasks,
    int? Function()? editingTaskId,
    bool? isSearching,
    String? searchQuery,
  }) {
    return TaskStateWithTasks(
      allTasks: allTasks ?? this.allTasks,
      visibleTasks: visibleTasks ?? this.visibleTasks,
      editingTaskId: editingTaskId == null ? this.editingTaskId : editingTaskId(),
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TaskInitial extends TaskState {}

class TaskFailure extends TaskState {
  final String message;

  TaskFailure(this.message);
}
