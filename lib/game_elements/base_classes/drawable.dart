import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

abstract mixin class Drawable {
  static late double canvasSize;
  static const double strokeWidth = 1;

  ///Should be called every time screen settings change. Ment to be used in [build] method of whole app
  static void setCanvasSize(Size size) {
    canvasSize = size.width;
  }

  ///Must call some variation of [super.draw] to appear on canvas
  void show(Canvas canvas);
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
}
