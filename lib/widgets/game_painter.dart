import 'package:flutter/material.dart';
import 'package:chromatic_chasm/game_state.dart';

class GamePainter extends CustomPainter with ChangeNotifier {
  Listenable? repaint;
  GameState state;
  GamePainter(this.state, {super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.src);
    state.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return hashCode != oldDelegate.hashCode;
  }
}
