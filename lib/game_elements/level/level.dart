library level;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/camera.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
part 'package:tempest/game_elements/level/level_entities.dart';

sealed class Level extends ComplexGlobalGameObject {
  final List<LevelTile> tiles;

  ///Whether player can move from last tile to first or vice versa
  final bool circlular;

  final double depth;

  /// Should be in non clock wise order, starting from 12 o'clock. First [tile.x] must be < 0
  Level._(Positionable pivot, this.tiles, this.depth, this.circlular) : super(pivot, tiles);

  /// Tile where player is. It has different color
  late int activeTile = tiles.length ~/ 2;

  /// [points] must be in range -100 to 100 in both x and y. [depth] prefered to be around 200
  ///
  /// Do not set [x] coordinate to 0 to prevent angle calculation issues. Use +-0.01 instead
  Level.fromPoints(Positionable pivot, List<Positionable> points, double depth, bool circlular)
      : this._(pivot, _pointsToTiles(pivot, points, depth, circlular), depth, circlular);

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    lastFrameTimestamp = frameTimestamp;
    for (final (i, tile) in tiles.indexed) {
      if (i != activeTile) {
        tile.onFrame(canvas, camera, frameTimestamp);
      }
      tiles[activeTile].onFrameActive(canvas, camera);
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
