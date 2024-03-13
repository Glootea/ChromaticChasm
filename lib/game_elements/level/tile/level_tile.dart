import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/camera.dart';
import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class LevelTile extends StatelessGlobalGameObject {
  ///The line where most enemies are move/exist
  TileMainLine get mainLine => _getMainLine;
  TileMainLine? _mainLine;

  TileMainLine get _getMainLine {
    _mainLine = TileMainLine(
      PositionFunctions.median(leftNearPointGlobal, rightNearPointGlobal),
      PositionFunctions.median(leftFarPointGlobal, rightFarPointGlobal),
    );
    return _mainLine!;
  }

  List<Positionable> toGlobalPoints(List<Positionable> points, Positionable pivot) =>
      points.map((point) => point + pivot).toList();

  /// [Points] are in order: left near, left far, right far, right near. All points must be
  LevelTile(super.pivot, super.drawable);

  ///Construct levelTile from 2 close points(in local coordinates) relative to pivot. Also gets depth to place far points
  LevelTile.from(Positionable pivot, Positionable left, Positionable rigth, double depth)
      : this(
            pivot,
            Drawable2D(pivot, [
              left,
              left + Positionable(0, 0, depth),
              rigth + Positionable(0, 0, depth),
              rigth
            ], [
              [0, 1, 2, 3]
            ]));
  List<double>? _angleRange;
  List<double> get angleRange => _angleRange ?? _calculateAngleRange();
  Positionable get leftNearPointGlobal => drawable.getGlobalVertexes[0];
  Positionable get leftFarPointGlobal => drawable.getGlobalVertexes[1];
  Positionable get rightFarPointGlobal => drawable.getGlobalVertexes[2];
  Positionable get rightNearPointGlobal => drawable.getGlobalVertexes[3];

  ///Used to determine if joystick points at this tile
  List<double> _calculateAngleRange() {
    final leftAngle = atan2(leftNearPointGlobal.x - pivot.x, leftNearPointGlobal.y - pivot.y);
    final rightAngle = atan2(rightNearPointGlobal.x - pivot.x, rightNearPointGlobal.y - pivot.y);
    _angleRange = [leftAngle, rightAngle];
    return _angleRange!;
  }

  static Paint defaultPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = Drawable.strokeWidth;

  static Paint activePaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    drawable.show(canvas, camera, defaultPaint);
  }

  void onFrameActive(Canvas canvas, Camera camera) {
    drawable.show(canvas, camera, activePaint);
  }

  double get angle {
    final delta = rightNearPointGlobal - leftNearPointGlobal;
    return atan2(delta.x, delta.y) - pi / 2;
  }

  double get width => (rightNearPointGlobal - leftNearPointGlobal).length;
}
