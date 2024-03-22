import 'dart:math';

class AngleGenerator {
  static final _random = Random();
  static double get getRandomAngle => _random.nextDouble() * 2 * pi;
}
