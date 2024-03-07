import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';

class Shot extends StatelessTileGameObject {
  Shot._(TilePositionable pivot) : super(pivot, Drawable3D(pivot, _vertices, _faces, _normals, width: 2));
  Shot(Level level, int tileNumber) : this._(TilePositionable(level, tileNumber, depthFraction: 0));

  static const _speed = 0.025;

  static final Paint paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;
  static final List<Positionable> _vertices = [
    Positionable(0.0, 1.0, 0.0),
    Positionable(-0.8660253882408142, 0.5, 0.0),
    Positionable(-0.8660253882408142, -0.5, 0.0),
    Positionable(0.0, -1.0, 0.0),
    Positionable(0.8660253882408142, -0.5, 0.0),
    Positionable(0.8660253882408142, 0.5, 0.0),
    Positionable(0.0, 1.0, 2.0),
    Positionable(-0.8660253882408142, 0.5, 2.0),
    Positionable(-0.8660253882408142, -0.5, 2.0),
    Positionable(0.0, -1.0, 2.0),
    Positionable(0.8660253882408142, -0.5, 2.0),
    Positionable(0.8660253882408142, 0.5, 2.0),
    Positionable(0.0, 0.0, 3.0)
  ];

  static final List<List<int>> _faces = [
    [0, 6, 11, 5],
    [4, 10, 9, 3],
    [2, 8, 7, 1],
    [5, 11, 10, 4],
    [3, 9, 8, 2],
    [1, 7, 6, 0],
    [8, 12, 7],
    [11, 12, 10],
    [9, 12, 8],
    [7, 12, 6],
    [6, 12, 11],
    [10, 12, 9],
    [1, 0, 5, 4, 3, 2]
  ];

  static final List<Positionable> _normals = [
    Positionable(0.5, 0.8660253882408142, 0.0),
    Positionable(0.5, -0.8660253882408142, 0.0),
    Positionable(-1.0, -0.0, 0.0),
    Positionable(1.0, -0.0, 0.0),
    Positionable(-0.5, -0.8660253882408142, 0.0),
    Positionable(-0.5, 0.8660253882408142, 0.0),
    Positionable(-0.7559289932250977, 0.0, 0.6546536684036255),
    Positionable(0.7559289932250977, 0.0, 0.6546536684036255),
    Positionable(-0.37796449661254883, -0.6546536684036255, 0.6546536684036255),
    Positionable(-0.37796449661254883, 0.6546536684036255, 0.6546536684036255),
    Positionable(0.37796449661254883, 0.6546536684036255, 0.6546536684036255),
    Positionable(0.37796449661254883, -0.6546536684036255, 0.6546536684036255),
    Positionable(0.0, 0.0, -0.9999999403953552)
  ];
  // @override
  // void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
  // _updatePosition(frameTimestamp);
  // final pivotOfShot = PositionFunctions.positionWithFraction(
  //   level.children[tileNumber].mainLine.close,
  //   level.children[tileNumber].mainLine.far,
  //   depthFraction,
  // );
  // drawLoopedLines(
  //     canvas,
  //     rotateZ(
  //       Positionable.zero(),
  //       localPoints,
  //       level.children[tileNumber].angle,
  //     ).toGlobal(pivotOfShot),
  //     paint);
  // }

  List<Positionable> get localPoints => [
        Positionable(-1.5, 0, 0),
        Positionable(-1.5, 0, 5),
        Positionable(-0.5, 0, 7),
        Positionable(0.5, 0, 7),
        Positionable(1.5, 0, 5),
        Positionable(1.5, 0, 0),
      ];

  void _updatePosition(DateTime frameTimestamp) {
    final dF = pivot.depthFraction +
        _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    pivot.updatePosition(dF);
    lastFrameTimestamp = frameTimestamp;
  }

  bool get disappear => pivot.depthFraction >= 0.95;

  @override
  void onFrame(Canvas canvas, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    drawable.show(canvas, paint);
  }
}
