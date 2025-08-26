import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/blocs/task/task_bloc.dart';
import 'package:todoapp/screens/home.screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<TaskBloc>(create: (_) => TaskBloc())],
      child: const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
