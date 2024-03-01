import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class LevelTile with Drawable {
  ValueNotifier<Positionable> _pivotNotifier;
  Positionable get _pivot => _pivotNotifier.value;
  List<Positionable> _localPoints;
  List<Positionable> globalPoints;

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

  static List<Positionable> toGlobalPoints(List<Positionable> points, Positionable pivot) =>
      points.map((point) => point + pivot).toList();

  /// [Points] are in order: left near, left far, right far, right near. All points must be
  LevelTile(this._pivotNotifier, this._localPoints)
      : globalPoints = toGlobalPoints(_localPoints, _pivotNotifier.value) {
    _pivotNotifier.addListener(() {
      globalPoints = toGlobalPoints(_localPoints, _pivot);
    });
    assert(_localPoints.length == 4);
  }

  ///Construct levelTile from 2 close points(in local coordinates) relative to pivot. Also gets depth to place far points
  LevelTile.from(ValueNotifier<Positionable> pivot, Positionable left, Positionable rigth, double depth)
      : this(pivot, [left, left + Positionable(0, 0, depth), rigth + Positionable(0, 0, depth), rigth]);

  List<double>? _angleRange;
  List<double> get angleRange => _angleRange ?? _calculateAngleRange();
  Positionable get leftNearPointGlobal => globalPoints[0];
  Positionable get leftFarPointGlobal => globalPoints[1];
  Positionable get rightFarPointGlobal => globalPoints[2];
  Positionable get rightNearPointGlobal => globalPoints[3];

  ///Used to determine if joystick points at this tile
  List<double> _calculateAngleRange() {
    final leftAngle = atan2(globalPoints[0].x - _pivot.x, globalPoints[0].y - _pivot.y);
    final rightAngle = atan2(globalPoints[3].x - _pivot.x, globalPoints[3].y - _pivot.y);
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
    drawLoopedLines(canvas, globalPoints, defaultPaint);
  }

  void showActive(Canvas canvas) {
    drawLoopedLines(canvas, globalPoints, activePaint);
  }

  double get angle {
    final delta = globalPoints.last - globalPoints.first;
    return atan2(delta.x, delta.y) - pi / 2;
  }
}
