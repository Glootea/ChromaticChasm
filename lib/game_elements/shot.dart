import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/helpers/positionable_list_extension.dart';

class Shot extends TilePositionable with Drawable {
  Shot(super.level, super.tileNumber, {super.depthFraction = 0});

  static const _speed = 0.025;

  static final Paint paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    final pivotOfShot = PositionFunctions.positionWithFraction(
      level.tiles[tileNumber].mainLine.close,
      level.tiles[tileNumber].mainLine.far,
      depthFraction,
    );
    drawLoopedLines(
        canvas,
        rotateZ(
          Positionable.zero(),
          localPoints,
          level.tiles[tileNumber].angle,
        ).toGlobal(pivotOfShot),
        paint);
  }

  List<Positionable> get localPoints => [
        Positionable(-1.5, 0, 0),
        Positionable(-1.5, 0, 5),
        Positionable(-0.5, 0, 7),
        Positionable(0.5, 0, 7),
        Positionable(1.5, 0, 5),
        Positionable(1.5, 0, 0),
      ];

  void _updatePosition(DateTime frameTimestamp) {
    depthFraction += _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    lastFrameTimestamp = frameTimestamp;
  }

  bool get disappear => depthFraction >= 0.95;
}
