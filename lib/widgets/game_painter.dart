import 'package:flutter/material.dart';

class GamePainter extends CustomPainter {
  Listenable? repaint;
  GamePainter({this.repaint}) : super(repaint: repaint);
  @override
  void paint(Canvas canvas, Size size) {
    print("Painted frame");
    // canvas.drawRect(Rect.largest, Paint()..color = Colors.blue);
    canvas.drawColor(Colors.black, BlendMode.src);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
