import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

abstract mixin class Drawable {
  static late double canvasSize;
  static const double strokeWidth = 1;

  /// Time in milliseconds between each frame to normalize game speed
  static const syncTime = 32;
  DateTime lastFrameTimestamp = DateTime.now();

  ///Should be called every time screen settings change. Ment to be used in [build] method of whole app
  static void setCanvasSize(Size size) {
    canvasSize = size.width;
  }

  ///Must call some variation of [super.draw] to appear on canvas
  ///
  ///Also should call [update] if needed
  void updateAndShow(Canvas canvas, DateTime frameTimestamp);

  void drawLoopedLines(Canvas canvas, List<Positionable> points, Paint paint) {
    final offsets = _project2D(points);
    for (int i = 0; i < offsets.length; i++) {
      canvas.drawLine(offsets[i], offsets[(i + 1) % offsets.length], paint);
    }
  }

  void drawLines(Canvas canvas, List<Positionable> points, Paint paint) {
    final offsets = _project2D(points);
    for (int i = 0; i < offsets.length - 1; i++) {
      canvas.drawLine(offsets[i], offsets[i + 1], paint);
    }
  }

  void drawCircle(Canvas canvas, Positionable point, Paint paint) {
    final offsets = _project2D([point]);
    canvas.drawCircle(offsets[0], 5, paint);
  }

  static const distanceToCamera = 0.0000000001;
  Offset _convert3DToOffset(Positionable point) {
    if (point.z <= 0) {
      point.z = 0.5;
    }

    final x = ((distanceToCamera * point.x / (point.z + distanceToCamera)) / (distanceToCamera * 4) + 0.5) * canvasSize;
    final y =
        (((distanceToCamera * point.y / (point.z + distanceToCamera)) / (distanceToCamera * 4)) + 0.5) * canvasSize;
    return Offset(x, y);
  }

  List<Offset> _project2D(List<Positionable> list) {
    return list.map((point) => _convert3DToOffset(point)).toList();
  }

  bool get avoidRedraw => DateTime.now().difference(lastFrameTimestamp).inMilliseconds < syncTime;

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> rotateX(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateXAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> rotateY(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateYAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> rotateZ(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateZAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
}
