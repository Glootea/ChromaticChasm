import 'package:flutter/material.dart';
import 'package:tempest/game_elements/level/level.dart';

class GamePainter extends CustomPainter {
  Listenable? repaint;
  Level level;
  GamePainter(this.level, {this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.src);
    level.show(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
