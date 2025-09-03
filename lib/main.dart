import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/injection/injection_container.dart';
import 'package:todoapp/presentation/navigation/routes.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/screens/blocs/task/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setUp();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(create: (_) => getIt<TaskBloc>()),
        BlocProvider<BackgroundCubit>(create: (_) => getIt<BackgroundCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
