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
  void show(Canvas canvas, DateTime frameTimestamp);

  void drawLooped(Canvas canvas, List<Positionable> points, Paint paint) {
    final offsets = _project2D(points);
    for (int i = 0; i < offsets.length; i++) {
      canvas.drawLine(offsets[i], offsets[(i + 1) % offsets.length], paint);
    }
  }

  void drawCircle(Canvas canvas, Positionable point, Paint paint) {
    final offsets = _project2D([point]);
    canvas.drawCircle(offsets[0], 5, paint);
  }

  Offset _convert3DToOffset(Positionable point) {
    const distanceToCamera = 500;
    final x = ((distanceToCamera * point.x / (point.z + distanceToCamera)) / 100 / 2 + 0.5) * canvasSize;
    final y = (((distanceToCamera * point.y / (point.z + distanceToCamera)) / 100) / 2 + 0.5) * canvasSize;
    return Offset(x, y);
  }

  List<Offset> _project2D(List<Positionable> list) {
    return list.map((point) => _convert3DToOffset(point)).toList();
  }

  List<Positionable> getRotatedLocalPoints(List<Positionable> points, double angle) =>
      _rotateZ(Positionable.zero(), points, angle);

  bool get avoidRedraw => DateTime.now().difference(lastFrameTimestamp).inMilliseconds < syncTime;

  List<Positionable> _rotateX(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateXAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
  List<Positionable> _rotateY(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateYAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
  List<Positionable> _rotateZ(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateZAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
}
