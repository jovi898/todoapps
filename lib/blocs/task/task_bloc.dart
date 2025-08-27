import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';
import 'package:uuid/uuid.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    final updated = List<Task>.of(state.allTasks);

    on<AddTask>((event, emit) {
      updated.add(Task(id: const Uuid().v4(), text: event.text));
      emit(TaskLoaded(allTasks: updated, visibleTasks: updated));
    });
    on<ToggleDone>((event, emit) {
      final index = updated.indexWhere((task) => task.id == event.taskId);
      if (index != -1) {
        final oldTask = updated[index];
        updated[index] = oldTask.copyWith(isDone: !oldTask.isDone);
        emit(TaskLoaded(allTasks: updated, visibleTasks: updated));
      }
    });
    on<ToggleFavorite>((event, emit) {
      final index = updated.indexWhere((task) => task.id == event.taskId);
      if (index != -1) {
        final oldTask = updated[index];
        updated[index] = oldTask.copyWith(favorite: !oldTask.favorite);
        emit(TaskLoaded(allTasks: updated, visibleTasks: updated));
      }
    });
    on<ToggleEditText>((event, emit) {
      final index = updated.indexWhere((task) => task.id == event.taskId);
      if (index != -1) {
        final oldTask = updated[index];
        updated[index] = oldTask.copyWith(text: event.newText);
        emit(TaskLoaded(allTasks: updated, visibleTasks: updated));
      }
    });
    on<SearchTasks>((event, emit) {
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(TaskLoaded(allTasks: state.allTasks, visibleTasks: state.allTasks));
      } else {
        final filtered = state.allTasks
            .where((task) => task.text.toLowerCase().contains(query))
            .toList();
        emit(TaskLoaded(allTasks: state.allTasks, visibleTasks: filtered));
      }
    });
    on<DeleteTask>((event, emit) {
      final updatedTasks = state.allTasks.where((task) => task.id != event.taskId).toList();
      emit(TaskLoaded(allTasks: updatedTasks, visibleTasks: updatedTasks));
    });
  }
}
