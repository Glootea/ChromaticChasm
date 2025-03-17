import 'dart:math';
import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';

class LevelProvider {
  LevelProvider();
  LevelProvider.withLevel(Level level)
    : _levels = [level],
      _isInitialized = true;

  List<Level> _levels = [];
  bool _isInitialized = false;

  Future<void> init(ChromaticChasmDatabase database) async {
    final activatedLevels = await database.getActivatedLevelIds();
    final levels = await Future.wait(activatedLevels.map(database.getLevel));
    _levels = levels;
    _isInitialized = true;
  }

  final _random = Random();

  Level getRandomLevel() {
    assert(_isInitialized, "Level provider must be initialized");
    return _levels[_random.nextInt(_levels.length)];
  }
}
