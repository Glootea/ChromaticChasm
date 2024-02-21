import 'package:flutter/material.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/player/player.dart';

class GamePainter extends CustomPainter {
  Listenable? repaint;
  Level level;
  Player player;
  GamePainter(this.level, this.player, {this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.src);
    level.show(canvas);
    player.show(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
