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

  Future<Iterable<LevelSelectionItem>> getUserGeneratedLevels() async {
    final levels = await _database.getUserGeneratedLevels();
    return levels.map((e) => e.toLevelSelectionItem());
  }

  Future<List<int>> getActivatedLevelIds() async =>
      _database.getActivatedLevelIds();

  Future<Level> getLevel(int id) async {
    final levelData = await _database.getLevelData(id);
    final level = levelData.toLevel();
    return level;
  }

  Future<void> updateLevelContent(Level level) async =>
      _database.updateLevelContent(level.toEntity());

  Future<void> updateLevelInfo(LevelSelectionItem level) async {
    _database.updateLevelInfo(level.toBasicLevelInfoData());
  }

  Future<int> insertLevelBasicInfo(LevelSelectionItem level) =>
      _database.insertLevel(level.toBasicLevelInfoData());

  Future<void> deleteLevel(LevelSelectionItem level) =>
      _database.deleteLevel(level.id);
}

@DriftDatabase(tables: [BasicLevelInfo, LevelContent])
class _Database extends _$_Database {
  _Database() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'chromatic_chasm_db',
      native: const DriftNativeOptions(),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // you can keep your onCreate and onUpgrade callbacks
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
      onCreate: (m) async {
        await m.createAll();
        final levels = [Level1(), Level2()];
        for (final level in levels) {
          await insertLevel(
            BasicLevelInfoCompanion(
              name: Value(level.runtimeType.toString()),
              id: Value(level.id),
              activated: const Value(true),
              userGenerated: const Value(false),
            ),
          );
          await updateLevelContent(level.toEntity());
        }
      },
      onUpgrade: (m, from, to) async {
        if (to == 8) {
          await m.drop(levelContent);
          await m.drop(basicLevelInfo);

          await m.createAll();
          final levels = [Level1(), Level2()];
          for (final level in levels) {
            await insertLevel(
              BasicLevelInfoCompanion(
                name: Value(level.runtimeType.toString()),
                id: Value(level.id),
                activated: const Value(true),
                userGenerated: const Value(false),
              ),
            );
            await updateLevelContent(level.toEntity());
          }
        }
      },
    );
  }

  Future<List<BasicLevelInfoData>> getLevels() => select(basicLevelInfo).get();
  Future<LevelContentData> getLevelData(int id) =>
      (select(levelContent)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> insertLevel(BasicLevelInfoCompanion level) async {
    final createdLevel = Level.create(level.id.value);
    final id = await into(basicLevelInfo).insert(
      BasicLevelInfoCompanion.insert(
        name: level.name.value,
        userGenerated: level.userGenerated,
        activated: level.activated,
      ),
      mode: InsertMode.insertOrFail,
    );
    await into(levelContent).insert(
      LevelContentCompanion.insert(
        circular: createdLevel.circlular,
        depth: createdLevel.depth,
        points: createdLevel.pointsToString(),
        id: Value(id),
      ),
      mode: InsertMode.insertOrFail,
    );
    return id;
  }

  Future<void> updateLevelContent(LevelContentCompanion level) =>
      update(levelContent).replace(level);

  Future<void> updateLevelInfo(BasicLevelInfoCompanion level) =>
      update(basicLevelInfo).replace(level);

  Future<void> deleteLevel(int id) =>
      (delete(basicLevelInfo)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<int>> getActivatedLevelIds() => (select(basicLevelInfo)..where(
    (tbl) => tbl.activated.equals(true),
  )).get().then((e) => e.map((e) => e.id).toList());

  Future<List<BasicLevelInfoData>> getUserGeneratedLevels() =>
      (select(basicLevelInfo)..where((tbl) => tbl.userGenerated)).get();
}
