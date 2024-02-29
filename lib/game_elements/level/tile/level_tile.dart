import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class LevelTile with Drawable {
  Positionable pivot;
  List<Positionable> points;

  ///The line where most enemies are move/exist
  TileMainLine get mainLine => _mainLine ?? _getMainLine;
  TileMainLine? _mainLine;

  TileMainLine get _getMainLine {
    _mainLine = TileMainLine(
      PositionFunctions.median(leftNearPointGlobal, rightNearPointGlobal),
      PositionFunctions.median(leftFarPointGlobal, rightFarPointGlobal),
    );
    return _mainLine!;
  }

  /// [Points] are in order: left near, left far, right far, right near. All points must be
  LevelTile(this.pivot, List<Positionable> _points) : points = _points.map((point) => point + pivot).toList() {
    assert(points.length == 4);
  }

  ///Construct levelTile from 2 close points(in local coordinates) relative to pivot. Also gets depth to place far points
  LevelTile.from(Positionable pivot, Positionable left, Positionable rigth, double depth)
      : this(pivot, [left, left + Positionable(0, 0, depth), rigth + Positionable(0, 0, depth), rigth]);

  List<double>? _angleRange;
  List<double> get angleRange => _angleRange ?? _calculateAngleRange();
  Positionable get leftNearPointGlobal => points[0];
  Positionable get leftFarPointGlobal => points[1];
  Positionable get rightFarPointGlobal => points[2];
  Positionable get rightNearPointGlobal => points[3];

  ///Used to determine if joystick points at this tile
  List<double> _calculateAngleRange() {
    final leftAngle = atan2(points[0].x - pivot.x, points[0].y - pivot.y);
    final rightAngle = atan2(points[3].x - pivot.x, points[3].y - pivot.y);
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
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    drawLoopedLines(canvas, points, defaultPaint);
  }

  void showActive(Canvas canvas) {
    drawLoopedLines(canvas, points, activePaint);
  }

  double get angle {
    final delta = points.last - points.first;
    return atan2(delta.x, delta.y) - pi / 2;
  }
}
