import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/domain/repositories/task_repository.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_loadAllTasks);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleDone>(_onToggleDone);
    on<ToggleFavorite>(_onToggleFavorite);
    on<StartEditingTask>(_onStartEditingTask);
    on<StopEditingTask>(_onStopEditingTask);
    on<UpdateTaskText>(_onUpdateTaskText);
    on<SearchTasks>(
      _onSearchTasks,
      transformer: (events, mappper) =>
          events.debounceTime(const Duration(milliseconds: 500)).switchMap(mappper),
    );
    on<StartSearch>(_onStartSearch);
    on<StopSearch>(_onStopSearch);

    add(LoadTasks());
  }

  Future<void> _loadAllTasks(LoadTasks _, Emitter<TaskState> emit) async {
    final updated = await repository.getAllTask();

    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    await repository.addTask(event.text);
    final updated = await repository.getAllTask();

    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    await repository.deleteTask(event.taskId);
    final updated = await repository.getAllTask();
    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onToggleDone(ToggleDone event, Emitter<TaskState> emit) async {
    await repository.toggleDone(event.taskId);
    final updated = await repository.getAllTask();
    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<TaskState> emit) async {
    await repository.toggleFavorite(event.taskId);
    final updated = await repository.getAllTask();
    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onStartEditingTask(StartEditingTask event, Emitter<TaskState> emit) {
    final currentState = state as TaskStateWithTasks;
    emit(currentState.copyWith(editingTaskId: () => event.taskId));
  }

  void _onStopEditingTask(StopEditingTask event, Emitter<TaskState> emit) {
    final currentState = state as TaskStateWithTasks;
    emit(currentState.copyWith(editingTaskId: () => null));
  }

  void _onUpdateTaskText(UpdateTaskText event, Emitter<TaskState> emit) async {
    await repository.updateText(event.taskId, event.newText);
    final updated = await repository.getAllTask();
    emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
  }

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    if (state is TaskStateWithTasks) {
      final current = state as TaskStateWithTasks;
      final query = event.query.toLowerCase();
      if (query.isEmpty) {
        emit(current.copyWith(visibleTasks: current.allTasks, searchQuery: '', isSearching: true));
      } else {
        final filtered = current.allTasks
            .where((t) => t.text.toLowerCase().contains(query))
            .toList();
        emit(current.copyWith(visibleTasks: filtered, searchQuery: query, isSearching: true));
      }
    }
  }

  void _onStartSearch(StartSearch event, Emitter<TaskState> emit) {
    if (state is TaskStateWithTasks) {
      final current = state as TaskStateWithTasks;
      emit(current.copyWith(isSearching: true));
    }
  }

  void _onStopSearch(StopSearch event, Emitter<TaskState> emit) {
    if (state is TaskStateWithTasks) {
      final current = state as TaskStateWithTasks;
      emit(current.copyWith(isSearching: false, visibleTasks: current.allTasks, searchQuery: ''));
    }
  }
}
