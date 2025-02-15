import 'package:chromatic_chasm/database/converters/level.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_state.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';
part 'tables/level.dart';

class ChromaticChasmDatabase {
  final _Database _database = _Database();
  ChromaticChasmDatabase();

  Future<Iterable<LevelSelectionItem>> getLevels() async {
    final levels = await _database.getLevels();
    return levels.map((e) => e.toLevelSelectionItem());
  }

  Future<Level> getLevel(int id) async {
    final levelData = await _database.getLevelData(id);
    final level = levelData.toLevel();
    return level;
  }

  Future<void> updateLevelContent(Level level) async =>
      _database.updateLevelContent(level.toEntity());

  Future<void> insertLevelBasicInfo(LevelSelectionItem level) =>
      _database.insertLevel(level.toBasicLevelInfoData());

  Future<void> deleteLevel(LevelSelectionItem level) =>
      _database.deleteLevel(level.id);
}

@DriftDatabase(tables: [BasicLevelInfo, LevelContent])
class _Database extends _$_Database {
  _Database() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'chromatic_chasm_db',
      native: const DriftNativeOptions(),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // you can keep your onCreate and onUpgrade callbacks
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  Future<List<BasicLevelInfoData>> getLevels() => select(basicLevelInfo).get();
  Future<LevelContentData> getLevelData(int id) =>
      (select(levelContent)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<void> insertLevel(BasicLevelInfoCompanion level) async {
    await into(levelContent).insert(
      Level.create(level.id.value).toEntity(),
      mode: InsertMode.insertOrReplace,
    );
    await into(basicLevelInfo).insert(level, mode: InsertMode.insertOrReplace);
  }

  Future<void> updateLevelContent(LevelContentCompanion level) =>
      into(levelContent).insert(level, mode: InsertMode.insertOrReplace);

  Future<void> deleteLevel(int id) =>
      (delete(basicLevelInfo)..where((tbl) => tbl.id.equals(id))).go();
}
