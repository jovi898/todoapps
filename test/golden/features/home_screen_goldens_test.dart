import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';
import 'package:todoapp/presentation/screens/home_screen.dart';

void main() {
  late TaskBloc taskBloc;
  late BackgroundCubit backgroundCubit;

  setUp(() {
    taskBloc = MockTaskBloc();
    backgroundCubit = MockBackgroundCubit();

    whenListen<TaskState>(taskBloc, const Stream.empty(), initialState: TaskStateWithTasks());

    whenListen<Uint8List?>(backgroundCubit, const Stream.empty());
  });

  setUpAll(() async {
    await loadAppFonts(); // Без этого будут проблемы со шрифтами
  });
  testGoldens('description', (tester) async {
    final builder = DeviceBuilder()
      ..addScenario(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>.value(value: taskBloc),
            BlocProvider<BackgroundCubit>.value(value: backgroundCubit),
          ],
          child: const HomeScreen(),
        ),
      );
    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'home_screen');
  });
}
