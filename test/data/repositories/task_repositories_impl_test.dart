import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/data/datasources/app_database.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/data/repositories/task_repositories_impl.dart';

void main() {
  late MockAppDatabase appDatabase;
  late TaskRepositoryImpl repository;
  const text = 'text';
  const id = 1;
  const todo = Todo(id: id, title: 'Todo', isdone: false, favorite: false);
  const todoIsDone = Todo(id: id, title: 'Todo', isdone: true, favorite: false);
  const todoIsFreeze = Todo(id: id, title: 'Todo', isdone: false, favorite: true);

  setUpAll(() {
    registerFallbackValue(TodosCompanionFake());
    registerFallbackValue(TodoFake());
    appDatabase = MockAppDatabase();
    repository = TaskRepositoryImpl(appDatabase);
  });

  test('Add Task', () async {
    when(
      () => appDatabase.insertTodo(const TodosCompanion(title: Value(text))),
    ).thenAnswer((_) async => 0);

    await repository.addTask(text);

    verify(() => appDatabase.insertTodo(const TodosCompanion(title: Value(text))));
  });

  test('Delete Task', () async {
    when(() => appDatabase.deleteTodo(id)).thenAnswer((_) async => 0);

    await repository.deleteTask(id);

    verify(() => appDatabase.deleteTodo(id));
  });

  test('Toggle Done if != null', () async {
    when(() => appDatabase.getTodoById(id)).thenAnswer((_) async => todo);
    when(() => appDatabase.updateTodo(any())).thenAnswer((_) async => true);

    await repository.toggleDone(id);

    verify(() => appDatabase.updateTodo(todoIsDone));
  });

  test('Toggle Done if == null', () async {
    when(() => appDatabase.getTodoById(id)).thenAnswer((_) async => null);

    await repository.toggleDone(id);

    verifyNever(() => appDatabase.updateTodo(any()));
  });

  test('Toggle freeze', () async {
    when(() => appDatabase.getTodoById(id)).thenAnswer((_) async => todo);
    when(() => appDatabase.updateTodo(any())).thenAnswer((_) async => true);

    await repository.toggleFreeze(id);

    verify(() => appDatabase.updateTodo(todoIsFreeze));
  });

  test('Toggle freeze if null', () async {
    when(() => appDatabase.getTodoById(id)).thenAnswer((_) async => null);

    await repository.toggleFreeze(id);

    verifyNever(() => appDatabase.updateTodo(any()));
  });

  test('Update Text', () async {
    when(() => appDatabase.getTodoById(id)).thenAnswer((_) async => todo);
    when(() => appDatabase.updateTodo(any())).thenAnswer((_) async => true);

    await repository.updateText(id, text);

    final captured = verify(() => appDatabase.updateTodo(captureAny())).captured.single;
    expect(captured.title, text);
  });
}
