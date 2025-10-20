import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/widgets/delete_slidable_task.dart';

void main() {
  final TaskBloc taskBloc = MockTaskBloc();
  const tasks = [Task(id: 1, text: 'Test task')];
  whenListen<TaskState>(
    taskBloc,
    const Stream.empty(),
    initialState: TaskStateWithTasks(visibleTasks: tasks),
  );
  group('Delete', () {
    testWidgets('description', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: BlocProvider.value(value: taskBloc, child: const DeleteSlideTask()),
          ),
        ),
      );

      final slidableItem = find.byKey(ValueKey(tasks[0].id));
      expect(slidableItem, findsOneWidget);
      await tester.drag(slidableItem, const Offset(-300, 0));
      await tester.pumpAndSettle();

      final iconDelete = find.widgetWithIcon(SlidableAction, Icons.delete);
      expect(iconDelete, findsOneWidget);
      await tester.tap(iconDelete);
      await tester.pumpAndSettle();

      verify(() => taskBloc.add(DeleteTask(1)));
    });
  });
}
