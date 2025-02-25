import 'dart:math';
import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';

class LevelProvider {
  final List<Level> _levels;

  LevelProvider({required List<Level> levels}) : _levels = levels;

  static Future<LevelProvider> create(ChromaticChasmDatabase database) async {
    final activatedLevels = await database.getActivatedLevelIds();
    final levels = await Future.wait(activatedLevels.map(database.getLevel));
    return LevelProvider(levels: levels);
  }

  final _random = Random();

  Level getRandomLevel() => _levels[_random.nextInt(_levels.length)];
}
