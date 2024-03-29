part of 'package:tempest/game_elements/level/level.dart';

/// V shape
class Level1 extends Level {
  Level1()
      : super.fromPoints(
            Positionable(0, 0, 50),
            [
              Positionable(-90, -40, 0),
              Positionable(-75, -20, 0),
              Positionable(-60, 0, 0),
              Positionable(-45, 20, 0),
              Positionable(-30, 40, 0),
              Positionable(-15, 60, 0),
              Positionable(0, 80, 0),
              Positionable(15, 60, 0),
              Positionable(30, 40, 0),
              Positionable(45, 20, 0),
              Positionable(60, 0, 0),
              Positionable(75, -20, 0),
              Positionable(90, -40, 0),
            ],
            200,
            false);
}

/// \+ shape
class Level2 extends Level {
  Level2()
      : super.fromPoints(
            Positionable(0, 0, 50),
            [
              Positionable(-0.01, -70, 0),
              Positionable(-30, -70, 0),
              Positionable(-30, -30, 0),
              Positionable(-70, -30, 0),
              Positionable(-70, 0, 0),
              Positionable(-70, 30, 0),
              Positionable(-30, 30, 0),
              Positionable(-30, 70, 0),
              Positionable(-0.01, 70, 0),
              Positionable(30, 70, 0),
              Positionable(30, 30, 0),
              Positionable(70, 30, 0),
              Positionable(70, 0, 0),
              Positionable(70, -30, 0),
              Positionable(30, -30, 0),
              Positionable(30, -70, 0),
            ],
            200,
            true);
}
