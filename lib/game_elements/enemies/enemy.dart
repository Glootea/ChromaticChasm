import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';

sealed class Enemy extends TilePositionable with Drawable {
  Enemy(super.level, super.tileNumber, {super.depthFraction = 1});

  bool checkPlayerHit(Player player) {
    final hit = player.tileNumber == tileNumber && depthFraction <= 0.02;
    return hit;
  }

  ///Returns number of shot, that hit this enemy
  ///
  ///Returns null if no shot hit
  int? shotHitNumber(List<Shot> shots) {
    for (int i = 0; i < shots.length; i++) {
      final shot = shots[i];
      final hit = shot.tileNumber == tileNumber && (shot.depthFraction - depthFraction).abs() < 0.05;
      if (hit) {
        _lifes -= 1;
        return i;
      }
    }
    return null;
  }

  int _lifes = 1;
  bool get checkDead => _lifes <= 0;

  void updatePosition(DateTime frameTimestamp);

  bool get disappear;
}

class Spider extends Enemy {
  Spider(super.level, super.tileNumber);

  LevelTile get tile => level.tiles[tileNumber];

  Positionable get _leftPointGlobal =>
      PositionFunctions.positionWithFraction(tile.leftNearPointGlobal, tile.leftFarPointGlobal, depthFraction);
  Positionable get _rightPointGlobal =>
      PositionFunctions.positionWithFraction(tile.rightNearPointGlobal, tile.rightFarPointGlobal, depthFraction);
  Positionable get _middlePointGlobal => PositionFunctions.median(_leftPointGlobal, _rightPointGlobal);

  ///Points depend on global [tile] points coordinates, so no more rotation is needed, unless rotation around [tile]
  List<List<Positionable>> get linesToDrawGlobal => [
        [
          _leftPointGlobal + Positionable(0, 0, -5),
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal) + Positionable(0, -5, -2.5),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal) + Positionable(0, -5, -2.5),
          _rightPointGlobal + Positionable(0, 0, -5)
        ],
        [
          _leftPointGlobal,
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal) + Positionable(0, -5, 0),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal) + Positionable(0, -5, 0),
          _rightPointGlobal
        ],
        [
          _leftPointGlobal + Positionable(0, 0, 5),
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal) + Positionable(0, -5, 2.5),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal) + Positionable(0, -5, 2.5),
          _rightPointGlobal + Positionable(0, 0, 5)
        ],
      ];

  static final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    for (final line in linesToDrawGlobal) {
      drawLines(canvas, line, _paint);
    }
  }

  static const _speed = 0.005;

  @override
  void updatePosition(DateTime frameTimestamp) {
    depthFraction -= _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    lastFrameTimestamp = frameTimestamp;
  }

  @override
  bool get disappear => depthFraction < 0;
}
