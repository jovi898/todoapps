import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/domain/repositories/task_repository.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  const id = 1;
  const text = 'text';
  final listOfTasks = [const Task(id: id, text: text)];
  final listOfTasksToggleId = [const Task(id: id, text: text, isDone: true)];
  final listOfTasksFreeze = [const Task(id: id, text: text, freeze: true)];

  setUp(() {
    repository = MockTaskRepository();
    when(() => repository.getAllTask()).thenAnswer((_) async => []);
  });

  blocTest<TaskBloc, TaskState>(
    'Load Tasks',
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    build: () => TaskBloc(repository),
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );

  blocTest<TaskBloc, TaskState>(
    'Add Task',
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
      when(() => repository.addTask(text)).thenAnswer((_) async {});
    },
    build: () => TaskBloc(repository),
    act: (bloc) => bloc.add(AddTask(text)),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );

  blocTest<TaskBloc, TaskState>(
    'Delete Task',
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => []);
      when(() => repository.deleteTask(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    build: () => TaskBloc(repository),
    act: (bloc) => bloc.add(DeleteTask(id)),
    expect: () => [TaskStateWithTasks()],
  );

  blocTest<TaskBloc, TaskState>(
    'Delete Task with Freeze',
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => []);
      when(() => repository.deleteTask(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    build: () => TaskBloc(repository),
    act: (bloc) => bloc.add(DeleteTask(id)),
    expect: () => [TaskStateWithTasks()],
  );

  blocTest<TaskBloc, TaskState>(
    'Toggle Done',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasksToggleId);
      when(() => repository.toggleDone(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(ToggleDone(id)),
    expect: () => [
      TaskStateWithTasks(allTasks: listOfTasksToggleId, visibleTasks: listOfTasksToggleId),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'Toggle Done with Freeze',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
      when(() => repository.toggleDone(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(ToggleDone(id)),
    expect: () => const <TaskState>[],
  );

  blocTest<TaskBloc, TaskState>(
    'Freeze Task',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasksFreeze);
      when(() => repository.toggleFreeze(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(FreezeTask(id)),
    expect: () => [
      TaskStateWithTasks(allTasks: listOfTasksFreeze, visibleTasks: listOfTasksFreeze),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'UnFreeze Task',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
      when(() => repository.toggleFreeze(id)).thenAnswer((_) async {});
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasksFreeze, visibleTasks: listOfTasksFreeze),
    act: (bloc) => bloc.add(UnFreezeTask(id)),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );

  blocTest<TaskBloc, TaskState>(
    'Start Editing Task',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(StartEditingTask(id)),
    expect: () => [
      TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks, editingTaskId: id),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'Start Editing Task with Freeze',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasksFreeze, visibleTasks: listOfTasksFreeze),
    act: (bloc) => bloc.add(StartEditingTask(id)),
    expect: () => const <TaskState>[],
  );

  blocTest<TaskBloc, TaskState>(
    'Stop Editing Task',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () =>
        TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks, editingTaskId: id),
    act: (bloc) => bloc.add(StopEditingTask()),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );

  blocTest<TaskBloc, TaskState>(
    'Update Task Text',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
      when(() => repository.updateText(id, text)).thenAnswer((_) async {});
    },
    act: (bloc) => bloc.add(UpdateTaskText(id, text)),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );

  blocTest<TaskBloc, TaskState>(
    'Search Tasks if empty',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(SearchTasks('')),
    expect: () => [
      TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks, isSearching: true),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'Search Tasks',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(SearchTasks(text)),
    expect: () {
      final filteredTasks = listOfTasks.where((t) => t.text.toLowerCase().contains(text)).toList();
      return [
        TaskStateWithTasks(
          allTasks: listOfTasks,
          visibleTasks: filteredTasks,
          isSearching: true,
          searchQuery: text,
        ),
      ];
    },
  );

  blocTest<TaskBloc, TaskState>(
    'Start Search',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks),
    act: (bloc) => bloc.add(SearchTasks('')),
    expect: () => [
      TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks, isSearching: true),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'Stop Search',
    build: () => TaskBloc(repository),
    setUp: () {
      when(() => repository.getAllTask()).thenAnswer((_) async => listOfTasks);
    },
    seed: () => TaskStateWithTasks(
      allTasks: listOfTasks,
      visibleTasks: listOfTasks,
      isSearching: true,
      searchQuery: text,
    ),
    act: (bloc) => bloc.add(StopSearch()),
    expect: () => [TaskStateWithTasks(allTasks: listOfTasks, visibleTasks: listOfTasks)],
  );
}
