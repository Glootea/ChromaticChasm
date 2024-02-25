import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/helpers/positionable_extension.dart';

class Shot extends TilePositionable with Drawable {
  Shot(super.level, super.tileNumber);

  static final Paint paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void show(Canvas canvas, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    final point = PositionFunctions.positionWithFraction(
        level.tiles[tileNumber].mainLine.close, level.tiles[tileNumber].mainLine.far, level.pivot, depthFraction);
    drawLooped(canvas, getRotatedLocalPoints(points, level.tiles[tileNumber].angle).toGlobal(point), paint);
  }

  List<Positionable> get points => [
        Positionable(-1.5, 0, 0),
        Positionable(-1.5, 0, 30),
        Positionable(-0.5, 0, 50),
        Positionable(0.5, 0, 50),
        Positionable(1.5, 0, 30),
        Positionable(1.5, 0, 0),
      ];
  void _updatePosition(DateTime frameTimestamp) {
    //TODO: time dependent movement
    depthFraction += 0.05 * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    lastFrameTimestamp = frameTimestamp;
  }

  bool get disappear => depthFraction >= 1;
}
