import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    final updated = List<Task>.of(state.tasks);
    on<AddTask>((event, emit) {
      updated.add(Task(event.text));
      emit(TaskLoaded(updated));
    });
    on<ToggleDone>((event, emit) {
      updated[event.index].isDone = !updated[event.index].isDone;
      emit(TaskLoaded(updated));
    });
    on<ToggleFavorite>((event, emit) {
      updated[event.index].favorite = !updated[event.index].favorite;
      emit(TaskLoaded(updated));
    });
    on<ToggleEditText>((event, emit) {
      final oldTask = updated[event.index];
      updated[event.index] = Task(
        event.newText,
        isDone: oldTask.isDone,
        favorite: oldTask.favorite,
      );
      emit(TaskLoaded(updated));
    });
    on<SearchTasks>((event, emit) {
      final filtred = state.tasks
          .where((task) => task.text.toLowerCase().contains(event.search.toLowerCase()))
          .toList();
      emit(TaskSearchResult(filtred));
    });
  }
}
