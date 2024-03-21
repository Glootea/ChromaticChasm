import 'package:flutter/material.dart';
import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/camera.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';

class Shot extends StatelessTileGameObject {
  Shot._(TilePositionable pivot)
      : super(pivot, Drawable3D(pivot, _vertices, _faces)..applyTransformation(scaleToWidth: 2));
  Shot(Level level, int tileNumber) : this._(TilePositionable(level, tileNumber, depthFraction: 0));

  static final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  static final List<Positionable> _vertices = [
    Positionable(0.0, 1.0, 0.0),
    Positionable(-0.87, 0.5, 0.0),
    Positionable(-0.87, -0.5, 0.0),
    Positionable(0.0, -1.0, 0.0),
    Positionable(0.87, -0.5, 0.0),
    Positionable(0.87, 0.5, 0.0),
    Positionable(0.0, 1.0, 2.0),
    Positionable(-0.87, 0.5, 2.0),
    Positionable(-0.87, -0.5, 2.0),
    Positionable(0.0, -1.0, 2.0),
    Positionable(0.87, -0.5, 2.0),
    Positionable(0.87, 0.5, 2.0),
    Positionable(0.0, 0.0, 3.0)
  ];

  static final List<List<int>> _faces = [
    [0, 5, 11, 6],
    [4, 3, 9, 10],
    [2, 1, 7, 8],
    [5, 4, 10, 11],
    [3, 2, 8, 9],
    [1, 0, 6, 7],
    [8, 7, 12],
    [11, 10, 12],
    [9, 8, 12],
    [7, 6, 12],
    [6, 11, 12],
    [10, 9, 12],
    [1, 2, 3, 4, 5, 0]
  ];

  final double _speed = 0.025;

  void _updatePosition(DateTime frameTimestamp) {
    final depthFraction = pivot.depthFraction +
        _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    pivot.updatePosition(depthFraction: depthFraction);
    lastFrameTimestamp = frameTimestamp;
  }

  bool get disappear => pivot.depthFraction >= 0.95;

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    drawable.show(canvas, camera, _paint);
  }
}
