import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/domain/repositories/task_repository.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late TaskBloc bloc;

  setUp(() {
    repository = MockTaskRepository();
    bloc = TaskBloc(repository);
    when(() => repository.getAllTask()).thenAnswer((_) async => []);
  });

  blocTest<TaskBloc, TaskState>(
    'event',
    build: () => bloc,
    act: (bloc) => bloc.add(AddTask('text')),
    expect: () => [
      isA<TaskStateWithTasks>().having((task) => task.allTasks.length, 'description', 1),
    ],
  );
}
