import 'package:flutter/material.dart';
import '../game_states/game_state.dart';

class GamePainter extends CustomPainter with ChangeNotifier {
  Listenable? repaint;
  final GameState _state;
  GamePainter(this._state, {super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.src);
    _state.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return hashCode != oldDelegate.hashCode;
  }
}
