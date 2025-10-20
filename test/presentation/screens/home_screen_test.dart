import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/screens/home_screen.dart';

void main() {
  const text = 'Hello';
  final TaskBloc taskBloc = MockTaskBloc();
  final BackgroundCubit backgroundCubit = MockBackgroundCubit();

  whenListen<TaskState>(taskBloc, const Stream.empty(), initialState: TaskStateWithTasks());

  whenListen<Uint8List?>(backgroundCubit, const Stream.empty());

  group("ListCard test:", () {
    testWidgets("should tap", (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider<BackgroundCubit>.value(value: backgroundCubit),
                BlocProvider<TaskBloc>.value(value: taskBloc),
              ],
              child: const HomeScreen(),
            ),
          ),
        ),
      );
      expect(find.text(LocaleKeys.NOTES), findsOneWidget);

      await tester.enterText(find.byKey(const Key('ADD_TASK')), text);
      await tester.pump();

      expect(find.text(text), findsOneWidget);

      final iconAdd = find.byIcon(Icons.add);
      expect(iconAdd, findsOneWidget);
      await tester.tap(iconAdd);

      verify(() => taskBloc.add(AddTask(text))).called(1);
    });
  });
}
