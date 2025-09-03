import 'package:todoapp/domain/entities/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> getAllTask();

  Future<void> addTask(String text);

  Future<void> deleteTask(int id);

  Future<void> toggleDone(int id);

  Future<void> toggleFreeze(int id);

  Future<void> updateText(int id, String newText);
}
