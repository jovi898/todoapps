import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/domain/entities/task.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/widgets/list_card.dart';

void main() {
  const id = 1;
  const text = 'text';
  const doneTask = Task(id: id, text: text, isDone: true, freeze: true);
  const task = Task(id: id, text: text);
  final TaskBloc taskBloc = MockTaskBloc();
  whenListen<TaskState>(taskBloc, const Stream.empty(), initialState: TaskStateWithTasks());
  group("ListCard test:", () {
    testWidgets("should tap", (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: BlocProvider.value(
              value: taskBloc,
              child: const Center(
                child: SizedBox(height: 50, width: 300, child: ListCard(task: task)),
              ),
            ),
          ),
        ),
      );

      await expectLater(find.byType(ListCard), matchesGoldenFile('list_card_golden.png'));

      expect(find.text(text), findsOneWidget);
      final checkFinder = find.byIcon(Icons.circle_outlined);
      await tester.tap(checkFinder);
      verify(() => taskBloc.add(ToggleDone(id)));

      final editIcon = find.byIcon(Icons.edit);
      await tester.tap(editIcon);
      verify(() => taskBloc.add(StartEditingTask(id)));

      final freezeIcon = find.byIcon(Icons.lock_open);
      await tester.tap(freezeIcon);
      verify(() => taskBloc.add(FreezeTask(id)));
    });
    testWidgets("should be lock and done", (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: BlocProvider.value(
              value: taskBloc,
              child: const ListCard(task: doneTask),
            ),
          ),
        ),
      );
      expect(find.text(text), findsOneWidget);

      final checkFinder = find.byIcon(Icons.check_circle);
      await tester.tap(checkFinder);
      verify(() => taskBloc.add(ToggleDone(id)));

      final freezeIcon = find.byIcon(Icons.block);
      await tester.tap(freezeIcon);
      verify(() => taskBloc.add(UnFreezeTask(id)));
    });
  });
}
