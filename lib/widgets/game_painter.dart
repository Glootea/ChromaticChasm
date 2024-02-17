import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/level/level.dart';

class GamePainter extends CustomPainter with ChangeNotifier {
  Listenable? repaint;
  GamePainter({this.repaint}) : super(repaint: repaint) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      level.activeTile = timer.tick % level.tiles.length;
      notifyListeners();
    });
  }
  final level = Level1();

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
