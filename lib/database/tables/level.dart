part of 'package:chromatic_chasm/database/database.dart';

class BasicLevelInfo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get activated => boolean().withDefault(const Constant(true))();
  BoolColumn get userGenerated => boolean().withDefault(const Constant(true))();
}

class LevelContent extends Table {
  IntColumn get id =>
      integer().references(
        BasicLevelInfo,
        #id,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.noAction,
        initiallyDeferred: true,
      )();
  BoolColumn get circular => boolean()();
  RealColumn get depth => real()();
  TextColumn get points => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
