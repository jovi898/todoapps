import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:todoapp/data/datasources/app_database.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockBackgroundCubit extends MockCubit<Uint8List?> implements BackgroundCubit {}

class MockAppDatabase extends Mock implements AppDatabase {}

class TodosCompanionFake extends Fake implements TodosCompanion {}

class TodoFake extends Fake implements Todo {}
