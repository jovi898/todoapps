import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/data/mocks/mocks.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';
import 'package:todoapp/presentation/widgets/drawer_task.dart';

void main() {
  final navigator = MockNavigator();
  final BackgroundCubit backgroundDrawer = MockBackgroundCubit();
  when(navigator.canPop).thenReturn(true);
  when(backgroundDrawer.pickBackgroundImage).thenAnswer((_) async {});

  group('DrawerTask:', () {
    testWidgets("should tap", (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: MockNavigatorProvider(
              navigator: navigator,
              child: BlocProvider.value(value: backgroundDrawer, child: const DrawerTasks()),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text(LocaleKeys.NAME_USER), findsOneWidget);

      final home = find.byIcon(Icons.home);
      await tester.tap(home);
      verify(navigator.pop);
      expect(find.text(LocaleKeys.HOME), findsOneWidget);

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text(LocaleKeys.SETTINGS), findsOneWidget);

      final wallpaper = find.byIcon(Icons.wallpaper);
      await tester.tap(wallpaper);
      verify(backgroundDrawer.pickBackgroundImage);
      expect(find.text(LocaleKeys.WALLPAPER), findsOneWidget);
    });
  });
}
