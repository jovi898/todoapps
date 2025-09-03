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
    on<FreezeTask>(_onFreezeToggle);
    on<UnFreezeTask>(_onUnFreezeToggle);
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
    try {
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await repository.addTask(event.text);
      final updated = await repository.getAllTask();

      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onToggleDone(ToggleDone event, Emitter<TaskState> emit) async {
    try {
      final currentState = state as TaskStateWithTasks;
      final task = currentState.allTasks.firstWhere((task) => task.id == event.taskId);

      if (task.freeze) return;
      await repository.toggleDone(event.taskId);
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onFreezeToggle(FreezeTask event, Emitter<TaskState> emit) async {
    try {
      await repository.toggleFreeze(event.taskId);
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onUnFreezeToggle(UnFreezeTask event, Emitter<TaskState> emit) async {
    try {
      await repository.toggleFreeze(event.taskId);
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onStartEditingTask(StartEditingTask event, Emitter<TaskState> emit) {
    try {
      final currentState = state as TaskStateWithTasks;
      final task = currentState.allTasks.firstWhere((t) => t.id == event.taskId);

      if (task.freeze) return;
      emit(currentState.copyWith(editingTaskId: () => event.taskId));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onStopEditingTask(StopEditingTask event, Emitter<TaskState> emit) {
    try {
      final currentState = state as TaskStateWithTasks;
      emit(currentState.copyWith(editingTaskId: () => null));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onUpdateTaskText(UpdateTaskText event, Emitter<TaskState> emit) async {
    try {
      await repository.updateText(event.taskId, event.newText);
      final updated = await repository.getAllTask();
      emit(TaskStateWithTasks(allTasks: updated, visibleTasks: updated));
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    try {
      if (state is TaskStateWithTasks) {
        final current = state as TaskStateWithTasks;
        final query = event.query.toLowerCase();
        if (query.isEmpty) {
          emit(
            current.copyWith(visibleTasks: current.allTasks, searchQuery: '', isSearching: true),
          );
        } else {
          final filtered = current.allTasks
              .where((t) => t.text.toLowerCase().contains(query))
              .toList();
          emit(current.copyWith(visibleTasks: filtered, searchQuery: query, isSearching: true));
        }
      }
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onStartSearch(StartSearch event, Emitter<TaskState> emit) {
    try {
      if (state is TaskStateWithTasks) {
        final current = state as TaskStateWithTasks;
        emit(current.copyWith(isSearching: true));
      }
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }

  void _onStopSearch(StopSearch event, Emitter<TaskState> emit) {
    try {
      if (state is TaskStateWithTasks) {
        final current = state as TaskStateWithTasks;
        emit(current.copyWith(isSearching: false, visibleTasks: current.allTasks, searchQuery: ''));
      }
    } catch (e) {
      emit(TaskFailure('Ошибка загрузки: $e'));
    }
  }
}
