import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_state.dart';
import 'package:drift/drift.dart';

extension LevelConverter on Level {
  LevelContentCompanion toEntity() => LevelContentCompanion.insert(
    id: Value(id),
    circular: circlular,
    depth: depth,
    points: pointsToString(),
  );
}

extension LevelDataConverter on LevelContentData {
  Level toLevel() => Level.fromPoints(
    id: id,
    circlular: circular,
    depth: depth,
    points: Level.stringToPoints(points),
  );
}

extension ToLevelSelectionItem on BasicLevelInfoData {
  LevelSelectionItem toLevelSelectionItem() =>
      LevelSelectionItem(id: id, name: name, activated: activated);
}

extension ToLevelSelectionData on LevelSelectionItem {
  BasicLevelInfoCompanion toBasicLevelInfoData() =>
      BasicLevelInfoCompanion.insert(
        id: Value(id),
        name: name,
        activated: Value(activated),
        content: id,
      );
}
