import 'dart:math';

import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';

class PositionableGenerator {
  static final _random = Random();
  static double _generateRandom(double min, double max) => min + _random.nextDouble() * (max - min);
  static Positionable aroundLevel(Level level) {
    final levelAmplitude = level.getLevelAmplitude();
    final x = _generateRandom(-150, 150);
    final y = _generateRandom(-150, 150);
    final z = _generateRandom(0, 300);
    final point = Positionable(x, y, z);
    if (point.x.abs() < levelAmplitude.x && point.y.abs() < levelAmplitude.y) {
      return aroundLevel(level);
    }
    return point;
  }
}
