import 'package:get_it/get_it.dart';
import 'package:todoapp/data/datasources/app_database.dart';
import 'package:todoapp/data/repositories/task_repositories_impl.dart';
import 'package:todoapp/domain/repositories/task_repository.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt
    ..registerLazySingleton(AppDatabase.new)
    ..registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(getIt()))
    ..registerFactory(() => TaskBloc(getIt()))
    ..registerLazySingleton(BackgroundCubit.new);
}
