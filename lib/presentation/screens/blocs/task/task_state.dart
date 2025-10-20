part of 'task_bloc.dart';

@immutable
sealed class TaskState extends Equatable {}

class TaskStateWithTasks extends TaskState {
  final List<Task> allTasks;
  final List<Task> visibleTasks;
  final int? editingTaskId;
  final bool isSearching;
  final bool isEditing;
  final String searchQuery;
  final bool isFrozen;

  TaskStateWithTasks({
    this.isEditing = false,
    this.allTasks = const [],
    this.visibleTasks = const [],
    this.editingTaskId,
    this.isSearching = false,
    this.searchQuery = "",
    this.isFrozen = false,
  });

  @override
  List<Object?> get props => [
    allTasks,
    visibleTasks,
    editingTaskId,
    isSearching,
    isEditing,
    searchQuery,
    isFrozen,
  ];

  TaskStateWithTasks copyWith({
    List<Task>? allTasks,
    List<Task>? visibleTasks,
    int? Function()? editingTaskId,
    bool? isSearching,
    String? searchQuery,
    bool? isFrozen,
  }) {
    return TaskStateWithTasks(
      allTasks: allTasks ?? this.allTasks,
      visibleTasks: visibleTasks ?? this.visibleTasks,
      editingTaskId: editingTaskId == null ? this.editingTaskId : editingTaskId(),
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      isFrozen: isFrozen ?? this.isFrozen,
    );
  }
}

class TaskInitial extends TaskState {
  @override
  List<Object?> get props => [];
}

class MyFrozen extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskFailure extends TaskState {
  final String message;

  TaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}
