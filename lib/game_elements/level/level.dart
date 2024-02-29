import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
import 'package:tempest/game_elements/base_classes/movable.dart';

sealed class Level with Drawable {
  ///Default [pivot] is [Movable(0, 0, 50)]
  Movable pivot;

  ///Whether player can move from last tile to first or vice versa
  final bool circlular;

  /// Should be in non clock wise order, starting from 12 o'clock. First [tile.x] must be < 0
  final List<LevelTile> tiles;

  Level(this.pivot, this.tiles, this.circlular);

  /// Tile where player is. It has different color
  late int activeTile = tiles.length ~/ 2;

  /// [points] must be in range -100 to 100 in both x and y. [depth] prefered to be around 1000
  Level.fromPoints(Movable pivot, List<Positionable> points, double depth, bool circlular)
      : this(pivot, _pointsToTiles(pivot, points, depth, circlular), circlular);

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
  static List<LevelTile> _pointsToTiles(Positionable pivot, List<Positionable> points, double depth, bool circlular) {
    final output = <LevelTile>[];
    for (int i = 0; i < points.length - 1; i++) {
      output.add(LevelTile.from(pivot, points[i], points[i + 1], depth));
    }
    if (circlular) {
      output.add(LevelTile.from(pivot, points.last, points.first, depth));
    }
    return output;
  }

  static final List<Level> _levels = [
    Level1(),
  ];
  static final _random = Random();
  static Level getRandomLevel() => _levels[_random.nextInt(_levels.length)];
}

class Level1 extends Level {
  static final Movable _level1Pivot = Movable(0, 0, 50);
  static final List<Positionable> _level1Points = [
    // Positionable(-0, -60, 0),
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
  ];
  Level1() : super.fromPoints(_level1Pivot, _level1Points, 200, false);
}
