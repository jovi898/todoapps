import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todoapp/injection/injection_container.dart';
import 'package:todoapp/main.dart';

void main() {
  const text = 'text';
  const textOther = 'textOther';
  const firstTaskKey = ValueKey(1);
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(configureDI);

  group('Integration Test', () {
    testWidgets('Интеграционный тест', (tester) async {
      await EasyLocalization.ensureInitialized();

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ru'), Locale('uz')],
          path: 'assets/translations',
          fallbackLocale: const Locale('ru'),
          child: const MainApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Открытие формы ввода
      final textField = find.byKey(const Key('ADD_TASK'));
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.pumpAndSettle();
      await tester.enterText(textField, text);
      await tester.pumpAndSettle();

      // Добавление задачи
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Нажатие на поиск 1
      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Открытие формы поиска
      final searchTextField = find.byKey(const Key('SEARCH_FIELD'));
      expect(searchTextField, findsOneWidget);

      await tester.tap(searchTextField);
      await tester.pumpAndSettle();
      await tester.enterText(searchTextField, text);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Закрытие формы поиска
      final searchNoButton = find.byIcon(Icons.close);
      expect(searchNoButton, findsOneWidget);
      await tester.tap(searchNoButton);
      await tester.pumpAndSettle();

      // Поиск текста 2
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(searchTextField);
      expect(searchTextField, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(searchTextField, textOther);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Закрытие формы поиска
      expect(searchNoButton, findsOneWidget);
      await tester.tap(searchNoButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text(text), findsOneWidget);

      final isDoneButton = find.byIcon(Icons.circle_outlined);
      expect(isDoneButton, findsOneWidget);
      await tester.tap(isDoneButton);
      await tester.pumpAndSettle();

      final editingButton = find.byIcon(Icons.edit);
      expect(editingButton, findsOneWidget);
      await tester.tap(editingButton);
      await tester.pumpAndSettle();

      final checkButton = find.byIcon(Icons.check);
      expect(checkButton, findsOneWidget);
      await tester.tap(checkButton);
      await tester.pumpAndSettle();

      final freezeButton = find.byIcon(Icons.lock_open);
      expect(freezeButton, findsOneWidget);
      await tester.tap(freezeButton);
      await tester.pumpAndSettle();

      final unFreezeButton = find.byIcon(Icons.block);
      expect(unFreezeButton, findsOneWidget);
      await tester.tap(unFreezeButton);
      await tester.pumpAndSettle();

      final slidableItem = find.byKey(firstTaskKey);
      expect(slidableItem, findsOneWidget);

      // Свайп
      await tester.drag(slidableItem, const Offset(-300, 0));
      await tester.pumpAndSettle();

      final deleteButton = find.widgetWithIcon(SlidableAction, Icons.delete);
      expect(deleteButton, findsOneWidget);
      await tester.pumpAndSettle();

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Drawer
      final openDrawer = find.byIcon(Icons.menu);
      expect(openDrawer, findsOneWidget);
      await tester.tap(openDrawer);
      await tester.pumpAndSettle();

      final home = find.byIcon(Icons.home);
      expect(home, findsOneWidget);
      await tester.tap(home);
      await tester.pumpAndSettle();

      expect(openDrawer, findsOneWidget);
      await tester.tap(openDrawer);
      await tester.pumpAndSettle();

      final settings = find.byIcon(Icons.settings);
      expect(settings, findsOneWidget);
      await tester.tap(settings);
      await tester.pumpAndSettle();
    });
  });
}
