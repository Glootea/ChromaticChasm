import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';

sealed class Level with Drawable {
  ///Default [pivot] is [Movable(0, 0, 50)]
  ValueNotifier<Positionable> pivot;

  ///Whether player can move from last tile to first or vice versa
  final bool circlular;

  final double depth;

  /// Should be in non clock wise order, starting from 12 o'clock. First [tile.x] must be < 0
  final List<LevelTile> tiles;

  Level._(this.pivot, this.tiles, this.depth, this.circlular);

  /// Tile where player is. It has different color
  late int activeTile = tiles.length ~/ 2;

  /// [points] must be in range -100 to 100 in both x and y. [depth] prefered to be around 1000
  ///
  /// Do not set [x] coordinate to 0 to prevent angle calculation issues. Use 0.01 instead
  Level.fromPoints(ValueNotifier<Positionable> pivot, List<Positionable> points, double depth, bool circlular)
      : this._(pivot, _pointsToTiles(pivot, points, depth, circlular), depth, circlular);

  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    lastFrameTimestamp = frameTimestamp;
    for (int i = 0; i < tiles.length; i++) {
      if (i != activeTile) {
        tiles[i].updateAndShow(canvas, frameTimestamp);
      }
      tiles[activeTile].showActive(canvas);
    }
  }

  ///Creates tiles iteratively by connecting [i] and [i+1] points. If circlular first and last points are connected
  static List<LevelTile> _pointsToTiles(
      ValueNotifier<Positionable> pivot, List<Positionable> points, double depth, bool circlular) {
    final output = <LevelTile>[];
    for (int i = 0; i < points.length - 1; i++) {
      output.add(LevelTile.from(pivot, points[i], points[i + 1], depth));
    }
    if (circlular) {
      output.add(LevelTile.from(pivot, points.last, points.first, depth));
    }
    return output;
  }

  static Level createLevel(int number) {
    switch (number) {
      case 0:
        return Level1();
      case 1:
        return Level2();
      default:
        return Level2();
    }
  }

  static Level getRandomLevel() => createLevel(Random().nextInt(2));
}

/// V shape
class Level1 extends Level {
  Level1()
      : super.fromPoints(
            ValueNotifier(Positionable(0, 0, 50)),
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
            ValueNotifier(Positionable(0, 0, 50)),
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
