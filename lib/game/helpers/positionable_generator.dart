import 'dart:math';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';

class PositionableGenerator {
  static final _random = Random();
  static double _generateRandom(double min, double max) =>
      min + _random.nextDouble() * (max - min);

  static Positionable aroundLevel(Level level) {
    const radius = 2 * Level.levelRadius;
    final x = _generateRandom(-radius, radius);
    final y = _generateRandom(-radius, radius);
    final z = _generateRandom(2 * level.pivot.z, 5 * level.pivot.z);
    final point = Positionable(x, y, z);

    return point;
  }
}
