import 'package:go_router/go_router.dart';
import 'package:todoapp/presentation/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeScreen())],
);
