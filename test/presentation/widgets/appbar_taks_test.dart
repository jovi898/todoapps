import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/widgets/appbar_tasks.dart';

void main() {
  final drawerKey = UniqueKey();
  final TaskBloc taskBloc = MockTaskBloc();
  whenListen<TaskState>(taskBloc, const Stream.empty(), initialState: TaskStateWithTasks());

  group("AppBar test:", () {
    testWidgets("should tap", (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: BlocProvider.value(
              value: taskBloc,
              child: Scaffold(
                appBar: const AppBarTasks(),
                drawer: Container(key: drawerKey),
              ),
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.TO_DO_LIST), findsOneWidget);

      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      verify(() => taskBloc.add(StartSearch()));

      final iconMenu = find.byIcon(Icons.menu);
      await tester.tap(iconMenu);
      await tester.pumpAndSettle();

      expect(find.byKey(drawerKey), findsOneWidget);
    });
  });
}
