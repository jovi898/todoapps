import 'package:drift/drift.dart';
import 'package:todoapp/data/datasources/app_database.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;

  const TaskRepositoryImpl(this.db);

  @override
  Future<void> addTask(String text) async {
    await db.insertTodo(TodosCompanion(title: Value(text)));
  }

  @override
  Future<void> deleteTask(int id) async {
    await db.deleteTodo(id);
  }

  @override
  Future<void> toggleDone(int id) async {
    final todo = await db.getTodoById(id);
    if (todo != null) {
      final updated = todo.copyWith(isdone: !todo.isdone);
      await db.updateTodo(updated);
    }
  }

  @override
  Future<void> toggleFreeze(int id) async {
    final todo = await db.getTodoById(id);
    if (todo != null) {
      final updated = todo.copyWith(favorite: !todo.favorite);
      await db.updateTodo(updated);
    }
  }

  @override
  Future<void> updateText(int id, String newText) async {
    final todo = await db.getTodoById(id);
    if (todo != null) {
      final updated = todo.copyWith(title: newText);
      await db.updateTodo(updated);
    }
  }

  @override
  Future<List<Task>> getAllTask() async {
    final todos = await db.getAllTodos();
    return todos
        .map(
          (todo) => Task(id: todo.id, text: todo.title, isDone: todo.isdone, freeze: todo.favorite),
        )
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
  }
}
