import 'package:drift/drift.dart';

class Todos extends Table {
  const Todos();

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  BoolColumn get isdone => boolean().withDefault(const Constant(false))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
}
