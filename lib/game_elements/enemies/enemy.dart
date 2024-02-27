import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/shot.dart';

sealed class Enemy extends TilePositionable with Drawable {
  Enemy(super.level, super.tileNumber, {super.depthFraction = 1});
  int life = 1;
  @override
  void show(Canvas canvas, DateTime frameTimestamp);

  bool checkPlayerHit() {
    // TODO: implement
    return false;
  }

  bool checkShotHit(Shot shot) {
    final hit = shot.tileNumber == tileNumber && (shot.depthFraction - depthFraction).abs() < 0.05;
    if (hit) life -= 1;
    return hit;
  }

  bool get checkDead => life <= 0;
  void updatePosition(DateTime frameTimestamp);
  bool get disappear;
}

class Spider extends Enemy {
  Spider(super.level, super.tileNumber);
  Positionable get _leftPoint => PositionFunctions.positionWithFraction(
      level.tiles[tileNumber].points[0], level.tiles[tileNumber].points[1], level.pivot, depthFraction);
  Positionable get _rightPoint => PositionFunctions.positionWithFraction(
      level.tiles[tileNumber].points[3], level.tiles[tileNumber].points[2], level.pivot, depthFraction);
  Positionable get _middlePoint => PositionFunctions.median(_leftPoint, _rightPoint);
  List<List<Positionable>> get points => [
        [
          _leftPoint + Positionable(0, 0, -5),
          PositionFunctions.median(_leftPoint, _middlePoint)..add(Positionable(0, -5, -2.5)),
          _middlePoint,
          PositionFunctions.median(_rightPoint, _middlePoint)..add(Positionable(0, -5, -2.5)),
          _rightPoint + Positionable(0, 0, -5)
        ],
        [
          _leftPoint,
          PositionFunctions.median(_leftPoint, _middlePoint)..add(Positionable(0, -5, 0)),
          _middlePoint,
          PositionFunctions.median(_rightPoint, _middlePoint)..add(Positionable(0, -5, 0)),
          _rightPoint
        ],
        [
          _leftPoint + Positionable(0, 0, 5),
          PositionFunctions.median(_leftPoint, _middlePoint)..add(Positionable(0, -5, 2.5)),
          _middlePoint,
          PositionFunctions.median(_rightPoint, _middlePoint)..add(Positionable(0, -5, 2.5)),
          _rightPoint + Positionable(0, 0, 5)
        ],
      ];
  static final Paint paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;
  @override
  void show(Canvas canvas, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    for (final element in points) {
      drawStraight(canvas, element, paint);
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
