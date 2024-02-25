import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/base_classes/transfromable.dart';

class Shot extends TilePositionable with Drawable, Transformable {
  Shot(super.tileMainLine, super.levelPivot);

  static final Paint paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void show(Canvas canvas) {
    _updatePosition();
    final point = PositionFunctions.positionWithFraction(
      level.tiles[level.activeTile].mainLine.close,
      level.tiles[level.activeTile].mainLine.far,
      level.pivot,
      depthFraction,
    );
    drawCircle(canvas, point, paint);
  }

  void _updatePosition() {
    depthFraction += 0.05;
  }
}
